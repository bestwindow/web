$ ->

  crawlChunk = (fn)->
    $.get "/chunks.json?#{(new Date()).getDate()}",(data)->
      dom = $ "#chunkSelector"
      html=''
      chunkid = $ "#chunkid"
      chunks = if chunkid.val()=="" then [] else chunkid.val().split ","
      chunker = (path)->
        for el in data
          return el if el.path is path.toLowerCase().trim()
        null
      checked = (id)->
        if chunks.indexOf(id)>=0 then "checked=checked" else ""
      template = (oc,lv,ends)->if oc then "<div class=\"chunks#{lv} #{ends||''}\"><div><input value=\"#{oc.id}\" type=checkbox class=chunks #{checked oc.id} />#{oc.title}</div>" else ""
      for key,value of chunkDef
        e1 = chunker key
        html+=template e1,1
        if value.push
          for e2 in value
            e2 = chunker e2
            html+="#{template e2,2,'ends2'}</div>"
        else
          for e2Key,e2Value of value
            e2 = chunker e2Key
            html+=template e2,2
            for e3 in e2Value
              e3 = chunker e3
              html+= "#{template e3,3}</div>"
            html+="</div>"
        html+='</div>'
      dom.html "请选择发布到哪个类别:#{html}"
      $('.chunks').bind 'click',(e)->
        dom = $ e.target
        chunkid = $ "#chunkid"
        chunks = if chunkid.val()=="" then [] else chunkid.val().split ","
        if dom.is ':checked'
          for i in [chunks.length-1..0]
            return true if chunks[i] ==dom.val()
          if dom.parents('.chunks3').length>0
            e2 = $ $(dom.parents '.chunks2').find('input')[0]
            e2.attr 'checked','checked'
            chunks.push e2.val() if chunks.indexOf(e2.val())<0
          if dom.parents('.chunks2').length>0
            e1 = $ $(dom.parents '.chunks1').find('input')[0]
            e1.attr 'checked','checked'
            chunks.push e1.val() if chunks.indexOf(e1.val())<0
          chunks.push dom.val() if chunks.indexOf(dom.val())<0
        else
          for i in [chunks.length-1..0]
            chunks.splice(i,1) if chunks[i] ==dom.val()
        chunkid.val chunks.join ","
      fn()
  
  
  updateInfo = ->
    $('#itemCrawler').addClass 'hide'
    $('.bookmark').addClass 'hide'
    $('#itemEditor').removeClass 'hide'
    crawlChunk initialize
  
  crawlImage = (imageUrl)->
    url = '/image/crawl'
    $("#crawlImageBtn").attr 'disabled',"disabled"
    $("#crawlImageBtn").attr 'value',"正在抓取"
    $.post url,url:imageUrl,(data)->
      data = JSON.parse data
      $("#crawlImageBtn").attr 'disabled',false
      $("#crawlImageBtn").attr 'value',"使用这张图片"
      return alert "图片抓取失败" if data.error
      showImage data[0]
      updateInfo()

           
  top.targetUrlBtnReset = (fn)->
    d = $("#targetUrlBtn")
    d.removeAttr 'disabled'
    d.attr 'value',"确定"
    fn()
  top.targetUrlBtnDisable = ->
    d = $("#targetUrlBtn")
    d.attr 'disabled',"disabled"
    d.attr 'value',"正在抓取" 
  crawUrl = (e)->
    domainList = ["taobao.com","tmall.com","amazon.com"]
    link = (l)->
      #http://detail.tmall.com/item.htm?id=17291880090&ali_trackid=2:mm_29801262_0_0,1001155510048686:1339946923_4z6_1948906727
      targetDomain = ->
        for el in domainList
          return el if l.indexOf(el)>0
        return false
      idPos = ->
        for el in ["?id=","&id=",]
          return el if l.indexOf(el)>0
        return false
      domain = targetDomain()
      return targetUrlBtnReset(->alert "目前只直至抓取taobao,tmall,amazon的商品信息") if domain==false
      if ["taobao.com","tmall.com"].indexOf(domain)>=0 
        idIndex = idPos()
        return targetUrlBtnReset(->alert "链接信息不完整,没有找到商品id") if idIndex==false
        idStr = l.split(idIndex)[1]
        id = idStr.split("&")[0]
        pureLink =  "http://detail.tmall.com/item.htm?id=#{id}"
      else if domain == "amazon.com"
        pureLink =l.split('/ref=')[0]
      $('#linkhidden').val pureLink
      true
    price = (p)->
      pr = parseFloat p
      if !isNaN pr
        $("#price").val pr
        $("#money").val pr
        true
      else
        false
    url = '/image/crawlurl'
    dom = $ "#targetUrlInput"
    return true if dom.val()=='' or !link dom.val()
    urlAndImageVal = $('#linkhidden').val()+$(('#imagelist')).val()
    targetUrlBtnDisable()
    $.post url,url:urlAndImageVal,(data)->
      data = JSON.parse(data).result
      $('#texthidden').val unescape data.title
      return targetUrlBtnReset(->$("#crawlerResult").html "没有抓取到价格") if price(data.price) ==false
      $("#targetUrlBtn").attr 'disabled',false
      $("#targetUrlBtn").attr 'value',"确定"
      return targetUrlBtnReset(->$("#crawlerResult").html "没有抓取到图片") if data.images.length<=0
      render = (sortBySize)->
        html = []
        for i in [0..data.images.length-1]
          imageUrl = data.images[i]
          if imageUrl && imageUrl !="" && imageUrl.indexOf("/")>0
            html.push "<div class=\"item span3\"><div><img id=\"crawlerImage#{i}\" src=\"#{imageUrl}\" onclick=setCrawlImage(this) /></div><div><a href=\"#{imageUrl}\" target=_blank><i class=icon-zoom-in></i><span class=title id=crawlerDiv#{i}></span></a></div>"
        if sortBySize
          htmlTemp = []
          for el in sortBySize
            for str in html when str.indexOf(el.imageId)>0 then break if htmlTemp.push str
          html = htmlTemp
          $('#imageCarousel .row-fluid').html html.join '</div>'
        else
          html = [
            "<div>共获得#{data.images.length}张图片&nbsp;&nbsp;&nbsp;&nbsp;"
            "<span id=crawlerInfo></span>"
            "<input type=button class=btn id=sizeImageBtn value=\"按大小排序\" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" 
            "<input type=button class=\"btn\" id=noImageBtn value=\"手动上传\">"
            "<input type=button class=\"btn btn-primary\" id=crawlImageBtn value=\"抓取图片\" />"
            "</div>"
            '<div id="imageCarousel">'
            '<div class=row-fluid>'
            html.join('</div>')
            '</div>'
            '</div>'
          ].join ""
          $("#crawlerResult").html html
        $("#crawlerResult .item img").load ->
          dom = $ this
          target = $ "#crawlerDiv#{dom.attr('id').replace('crawlerImage','')}"
          size = width:dom.width(),height:dom.height()
          target.html size.width+" X "+size.height
          if size.width > size.height
            dom.css "width","132px"
          else
            dom.css "height","152px"
      render()
      top.setCrawlImage = (dom)->
        dom = $ dom
        if top.CrawlImageParent
          top.CrawlImageParent.css "background",'gray'
        top.CrawlImageParent = $ dom.parents ".item"        
        top.CrawlImageParent.css "background",'orange'
        top.CrawlImage = dom.attr "src"
      $('#sizeImageBtn').click ->
        sizes = $ "#imageCarousel .item .title"
        area = []
        for size in sizes
          sizeTemp = $(size).html().split 'X'
          area.push 
            imageId:"crawlerImage#{$(size).attr('id').replace('crawlerDiv','')}"
            area:(if sizeTemp.length<2 then 0 else parseInt(sizeTemp[0],10)*parseInt(sizeTemp[1]))
        area.sort (a,b)->b.area - a.area
        render area
      $("#crawlImageBtn").click ->
        crawlImage top.CrawlImage if top.CrawlImage
      
      $("#noImageBtn").click ->
        updateInfo()

  
      

  showImage = (file)->
    $("#pictureinput")[0].value = file.thumbnail_url.split("image/")[1].replace("_0.jpg", "")
    $("#fileupload").css "display", "none"
    $(".left").css "border", "8px solid #eee"
    $("<div>").html("<a href=#{file.url} target=_blank><img src=#{file.url} width=430 /></a>").appendTo $("#fileresult")
    $('#pictureclose').css "display","block"
    

  $.money = ->
    $("#money").maskMoney
      symbol: "￥ "
      showSymbol: true
      symbolStay: true
      precision: 0

  initialize = ->
    $("#fileupload").fileupload
      dataType: "json"
      url: "/image"
      formData:type:"item"
      done: (e, data) ->
        $.each data.result, (index, file) ->showImage file
    $.epicEditor = new EpicEditor document.getElementById 'text'
    $.epicEditor.$filename = 'editor'
    $.epicEditor.remove $.epicEditor.$filename
    $.epicEditor.options(
      file:defaultContent:decodeURI($('#texthidden').val()),name:$.epicEditor.$filename
      basePath:"/_libs/epiceditor"
      themes:
        preview:'/themes/preview/github.css'
        editor:'/themes/editor/epic-light.css'
    ).load()


    $('#pictureclose').click (e)->
      e.target.style.display='none'
      $("#pictureinput")[0].value = ''
      $("#fileupload").css "display", "block"
      $(".left").css "border", "8px dashed #CCC"
      $("#fileresult").html ''


    $("#money").focus (e) ->
      if e.target.value is "￥"
        e.target.value = ""
        $.money()

    $("#money").keyup (e) ->
      unless e.target.value is "￥" or e.target.value is "" or e.target.value is "￥ "
        money = parseInt($.trim(e.target.value.replace(/￥/g, "").replace(/,/g, "").replace(/%/g, "")), 10)
        $("#price").val money  unless isNaN(money)


    $("#item-form").submit (e) ->
      noerror   = true
      alertDom  = $ ".alert"
      text      = $ "#texthidden"
      html      = $ '#htmlhidden'
      price     = $ "#price"
      picture   = $ "#pictureinput"
      chunkid   = $ "#chunkid"
      alertr    = (text)->
        alertDom.html text
        noerror = false
      before    = ->
        text.val $.epicEditor.get('editor').value
      validate  = ->
        if chunkid.val() is "" or chunkid.val() is "undefined"
          alertr "请选择发布到哪个类别"
        else if picture.val() is ""
          alertr "请上传一张货物图片"
        else if text.val() is "" or text.val() is "货物描述"
          alertr "请填写货物描述"
        else if price.val() is "" or parseInt(price.val()) is 0
          alertr "请填写货物价格"
      after     = ->
        html.val $.epicEditor.exportHTML()
        if noerror is false
          alertDom.addClass "alert-error"
          alertDom.addClass "in"
      before()
      validate()
      after()
      noerror


    if $('#price').val()!='' 
      $("#money").val $('#price').val()
      $.money()
      $("#money").mask()
    
    if $('#pictureinput').val()!=''
      $('#pictureclose').css "display","block"
      
      
  (->
    
    $("#targetUrlBtn").bind 'click',crawUrl
    $("#targetUrlInput").keyup (event)->
      crawUrl() if event.type == "keyup" && event.which == 13# [ENTER]
    
    crawlChunk initialize if $('#itemCrawler').length==0
    
    if $('#imagelist').length>0
      $('#imagelist').val decodeURIComponent $('#imagelist').val().replace /\~/g,'.'      
    
    if $('#website').length>0
      input = $ '#website'
      url   = decodeURIComponent input.val().replace /\~/g,'.'
      if url is '' then return true
      if url.indexOf('http://')<0 then url = 'http://'+url
      $("#targetUrlInput").val url
      $("#targetUrlBtn").trigger 'click'
  )()
  
  


