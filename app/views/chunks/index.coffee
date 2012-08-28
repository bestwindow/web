javascriptTag "/_j/jquery.masonry.js"

coffeescript ->
  $ ->
    $container = $('#items')
    $container.imagesLoaded -> $container.masonry itemSelector:'.item'


contentFor "title", "Listing chunks"


ul class:"breadcrumb",=>
  li ->
    a href:'/', '首页'
    span class:"divider",'/'
  li class:"active",'分类'
  if @isMaster()
    li class:"pull-right",=> 
      linkTo '+新建分类', urlFor(App.Chunk, action: "new")

span "按分类查看:"
for chunk in @chunks
  span ->
    text "&nbsp;&nbsp;&nbsp;&nbsp;"
    linkTo chunk.title,"/chunks/#{chunk.path}"

h3 '有什么新货物:'
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

