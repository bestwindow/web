javascriptTag "/_j/jquery.masonry.js"

coffeescript ->
  $ ->
    $container = $('#items')
    $container.imagesLoaded -> $container.masonry itemSelector:'.item'

contentFor "title", "Ghost #{@ghost.toLabel()}"

ul class:"breadcrumb",=>
  li ->
    a href:'/', '首页'
    span class:"divider",'/'
  li class:"active", =>"#{@ghost.name}的首页"


h2 "#{@ghost.name}发布的货物"
div id:"items", =>
  for item in @items
    div class:"item",=>
      div class:"item_picture",=>
        a href:"/items/#{item.get('id')}", ->
          img src:"/image/#{item.get('picture')}_1.jpg"
      div class:"item_text",->
        linkTo "#{item.get('text').split('\r\n')[0]}","/items/#{item.get('id')}"
      div class:"item_price",->
        linkTo "#{item.get('price')}","/items/#{item.get('id')}"

partial "shared/paginate"