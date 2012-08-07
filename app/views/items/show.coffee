contentFor "title", "Item #{@item.toLabel()}"
script ->
  if @request.user && @request.user.favorit && @request.user.favorit.length && @request.user.favorit.length>0
    text "var favorits = ['#{@request.user.favorit.join('\',\'')}']"
  else
    text "var favorits = []"
it = @item
edit = if App.GhostHelper.isSelf.bind(this,@ghost.id)() then true else false
if edit
  div class:"page-title",->
    text "商品详情"
    a href:"/items/#{it.id}/edit",->"编辑商品"
else
  div class:"page-title",->"商品详情"

div class:"item-index row-fluid",->
  div class:"item span9",->
    div class:"img", ->
      a href:"/items/#{it.id}",->
        img src:"/image/#{it.picture}_5.jpg",title:it.text.split("\r\n")[0]
    div class:"html", ->
      div ->it.html
      div class:"operation",->
        span class:"price", ->"￥#{it.price}"
        a href:"#{it.link}",target:"_blank",->"购买"
        a class:"favorits hide",id:"favorit-#{it.id}",href:"#",onclick:"favorit.toggle(event);return false",->"收藏"
        a href:"#",onclick:"shareBtnClick('#{Tower.domain}','#{it.id}','#{it.picture}','#{it.text}');return false",->"分享"
        span class:"pull-right",->
          chunkString = ["相似品味的"]
          chunkString.push "<a href=/chunks/#{chunk.path}>#{chunk.title}</a>" for chunk in it.chunk
          text chunkString.join '&nbsp;'
    div "&nbsp;"
    recommendHtml = []
    if it.recommend
      for i in [0..it.recommend.length-1]
        el = it.recommend[i]
        if el
          recommendHtml.push ck.render (->
            item = this
            div class:"span4",->
              div class:"item_picture",->
                a href:"/items/#{item.get('id')}", ->
                  img src:"/image/#{item.get('picture')}_1.jpg",title:item.text.split("\r\n")[0]
              div class:"html", ->
                item.text.split("\r\n")[0]
              div class:"operation hide",->
                span class:"price", ->"￥#{item.price}"
                text "&nbsp;"
                a href:"#{item.link}",target:"_blank",->"购买"
                text "&nbsp;"
                a class:"favorits hide",id:"favorit-#{item.id}",href:"#",onclick:"favorit.toggle(event);return false",->"收藏"
                text "&nbsp;"
                a href:"#",onclick:"shareBtnClick('#{Tower.domain}','#{item.id}','#{item.picture}','#{item.text}');return false",->"分享"
          ),el
        if (i+1)%3 is 0 or (it.recommend.length<3 and i is it.recommend.length-1)
          div class:"recommend-index row-fluid",->
            text recommendHtml.join ''
          recommendHtml=[]