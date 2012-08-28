javascriptTag "/_j/jquery.masonry.js"

coffeescript ->
  $ ->
    $container = $('#items')
    $container.imagesLoaded -> $container.masonry itemSelector:'.item'

contentFor "title", "Chunk #{@chunk.toLabel()}"




ul class:"breadcrumb",=>
  li ->
    a href:'/', '首页'
    span class:"divider",'/'
  li ->
    a href:'/chunks', '分类'
    span class:"divider",'/'       
  li class:"active", =>"#{@chunk.title}"
  li class:"pull-right",=> 
    a href:"/items/new/#{@chunk.get('path')}",->"+新建货物"

div id:"items", =>
  for item in @items
    div class:"item",=>
      div class:"item_picture",=>
        a href:"/items/#{item.get('id')}", ->
          img src:"/image/#{item.get('picture')}_1.jpg"
      div class:"item_text",->
        linkTo "#{item.get('text').split('\r\n')[0]}","/items/#{item.get('id')}"
      div class:"item_price",->
        span class:"label label-warning",->if item.price!='' then "￥#{item.price}"


partial "shared/paginate"



