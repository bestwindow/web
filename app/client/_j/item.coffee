$ ->
  
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
      $('#itemCrawler').addClass 'hide'
      $('#itemEditor').removeClass 'hide'
      initialize()
                  
  crawUrl = (e)->
    link = (l)->
      #http://detail.tmall.com/item.htm?id=17291880090&ali_trackid=2:mm_29801262_0_0,1001155510048686:1339946923_4z6_1948906727
      targetDomain = ->
        for el in ["taobao","tmall"]
          return el if l.indexOf(el)>0
        return false
      idPos = ->
        for el in ["?id=","&id="]
          return el if l.indexOf(el)>0
        return false
      domain = targetDomain()
      return alert "目前只直至抓取taobao.com, tmall.com下的商品信息" if domain==false
      idIndex = idPos()
      return alert "链接信息不完整,没有找到商品id" if idIndex==false   
      idStr = l.split(idIndex)[1]
      id = idStr.split("&")[0]
      pureLink =  "http://detail.tmall.com/item.htm?id=#{id}"
      $('#linkhidden').val pureLink
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
    return true if dom.val()==''
    link dom.val()
    $("#targetUrlBtn").attr 'disabled',"disabled"
    $("#targetUrlBtn").attr 'value',"正在抓取"
    $.post url,url:dom.val(),(data)->
      data = JSON.parse(data).result
      $('#texthidden').val unescape data.title
      return $("#crawlerResult").html "没有抓取到价格" if price(data.price) ==false
      html = []
      $("#targetUrlBtn").attr 'disabled',false
      $("#targetUrlBtn").attr 'value',"确定"
      return $("#crawlerResult").html "没有抓取到图片" if data.images.length<=0
      for imageUrl in data.images
        html.push "<div class=item><img id=\"crawlerImage\" src=#{imageUrl} onclick=crawlImage(this.src) />"
      html = [
        "<div>共获得#{data.images.length}张图片&nbsp;&nbsp;&nbsp;&nbsp;"
        "<input type=button onclick=\"$('#imageCarousel').carousel('prev')\" value=\"&lsaquo;\" />"
        "<input type=button onclick=\"$('#imageCarousel').carousel('next')\" value=\"&rsaquo;\" />&nbsp;&nbsp;&nbsp;&nbsp;"
        "<span id=crawlerInfo></span>"
        "<input type=button id=crawlImageBtn value=\"使用这张图片\" />"  
        "</div>"
        '<div id="imageCarousel" class="carousel slide">'
        '<div class="carousel-inner">'
        html.join('</div>')
        '</div>'
        '</div>'
      ].join ""
      $("#crawlerResult").html html
      $($('#imageCarousel .item')[0]).addClass 'active'
      $("#crawlImageBtn").click ->
        crawlImage $('#imageCarousel .active img').attr "src"
      showSize = ()->
        d = $ '#imageCarousel .active img'
        $('#crawlerInfo').html "图片长宽:#{d.width()} X #{d.height()}"
      setTimeout showSize,2500
      dom = $ '#imageCarousel'
      dom.carousel interval:6000000
      dom.on 'slid',showSize
    
  $("#targetUrlBtn").click crawUrl
  $("#targetUrlInput").keyup (event)->
    crawUrl() if event.type == "keyup" && event.which == 13# [ENTER]
      
      

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
      alertr    = (text)->
        alertDom.html text
        noerror = false
      before    = ->
        text.val $.epicEditor.get('editor').value
      validate  = ->
        if picture.val() is ""
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
      
      
  initialize() if $('#itemCrawler').length==0







