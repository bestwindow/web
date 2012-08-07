script ->
  if @request.user && @request.user.favorit && @request.user.favorit.length && @request.user.favorit.length>0
    text "var favorits = ['#{@request.user.favorit.join('\',\'')}']"
  else
    text "var favorits = []"


contentFor "title", "Chunk #{@chunk.toLabel()}"




div class:"page-title", => @chunk.title

div id:"items", ->
  for item in @items
    div class:"item chunk-show",->
      div class:"item_picture",->
        a href:"/items/#{item.get('id')}", ->
          img src:"/image/#{item.get('picture')}_1.jpg",title:item.text.split("\r\n")[0]
      div class:"html", ->
        item.text.split("\r\n")[0]
      div class:"operation",->
        span class:"price", ->"￥#{item.price}"
        a href:"#{item.link}",target:"_blank",->"购买"
        a class:"favorits hide",id:"favorit-#{item.id}",href:"#",onclick:"favorit.toggle(event);return false",->"收藏"
        a href:"#",onclick:"shareBtnClick('#{Tower.domain}','#{item.id}','#{item.picture}','#{item.text.replace(/'/g,"\\\'").replace(/(\n|\r|(\r\n)|(\u0085)|(\u2028)|(\u2029))/g, " ")}');return false",->"分享"


partial "shared/paginate"
contentFor "bottom", ->
  javascriptTag "/_j/jquery.masonry.js"
  coffeescript ->
    $ ->
      $container = $('#items')
      $container.imagesLoaded -> $container.masonry itemSelector:'.item'



