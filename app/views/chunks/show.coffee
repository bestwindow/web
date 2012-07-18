javascriptTag "/_j/jquery.masonry.js"

coffeescript ->
  $ ->
    $container = $('#items')
    $container.imagesLoaded -> $container.masonry itemSelector:'.item'

contentFor "title", "Chunk #{@chunk.toLabel()}"




ul class:"breadcrumb",=>      
  li class:"active", =>"#{@chunk.title}"
  li class:"pull-right",=> 
    a href:"/items/new/#{@chunk.get('path')}",->"+新建货物"

div id:"items", =>
  for item in @items
    div class:"item chunk-show",=>
      div class:"item_picture",=>
        a href:"/items/#{item.get('id')}", ->
          img src:"/image/#{item.get('picture')}_1.jpg"
      div class:"html", ->
        item.text.split("\r\n")[0]
      div class:"operation",->
        span class:"price", ->"￥#{item.price}"
        a href:"#{item.link}",target:"_blank",->"购买"


partial "shared/paginate"



