contentFor "title", "Item #{@item.toLabel()}"


edit = if App.GhostHelper.isSelf.bind(this,@ghost.id)() then true else false

div class:"content",id:"itemshow",=>
  div class:"header row-fluid",=>
    div class:"span7",=>
      a href:"#",=>
        abbr class:"timeago",title:"#{@item.createdAt}",=>
          @item.createdAt
    div class:"span4 pull-right",->
  div class:"title",=>
    @item.title
  div class:"picture", =>
    img src:"/image/#{@item.picture}_3.jpg"
  div class:"html",=>
    @item.html
  div class:"footer",=>
    span =>
      text "目录："
      a href:"/chunks/#{@chunk.path}", "#{@chunk.title}"
    if edit
      div class:"pull-right",=>
        a href:"/items/#{@item.id}/edit",->"编辑"

contentFor "bottom", ->
  javascriptTag "/_j/jquery.timeago.js"
  javascriptTag "/_j/jquery.timeago.zh-CN.js"
  coffeescript ->
    $ ->
      $("abbr.timeago").timeago()
