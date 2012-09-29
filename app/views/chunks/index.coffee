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

div ""

partial "shared/paginate"

