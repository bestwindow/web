javascriptTag "/_j/jquery.masonry.js"
coffeescript ->
  $ ->
    $container = $('#items')
    $container.imagesLoaded -> $container.masonry itemSelector:'.item'

contentFor "title", "Ghost #{@ghost.toLabel()}"
javascriptTag "/_j/ghost.js"

script ->
  if @request.user && @request.user.favorit && @request.user.favorit.length && @request.user.favorit.length>0
    text "var favorits = ['#{@request.user.favorit.join('\',\'')}']"
  else
    text "var favorits = []"


h2 '我的收藏'
div id:"items", =>
  for item in @items
    div class:"item chunk-show",=>
      div class:"item_picture",=>
        a href:"/items/#{item.get('id')}", ->
          img src:"/image/#{item.get('picture')}_1.jpg"
      div class:"html", ->
        item.html
      div class:"operation",->
        span class:"price", ->"￥#{item.price}"
        a href:"#{item.link}",target:"_blank",->"购买"
        a class:"favorits favoriteslist",id:"favorit-#{item.id}",href:"#",onclick:"favorit.toggle(event);return false",->"收藏"

partial "shared/paginate"