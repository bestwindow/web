div class:"item-index",id:"item-index",->
  for item in @items
    div class:"item",->
      div class:"header row-fluid",->
        div class:"span7",->
          a href:"/items/#{item.id}",->
            abbr class:"timeago",title:"#{item.createdAt}",->
              item.createdAt
        div class:"span4 pull-right",->
      div class:"title",->
        item.title
      div class:"image", ->
        a href:"/items/#{item.id}",->
          img src:"/image/#{item.picture}_3.jpg",title:item.text.split("\r\n")[0]
      div class:"html", ->
        text item.html.split('<hr>')[0]
        if item.html.indexOf('<hr>')>0
          a href:"/items/#{item.id}",->"继续阅读"

partial "shared/paginate"
contentFor "bottom", ->
  javascriptTag "/_j/jquery.masonry.js"
  javascriptTag "/_j/jquery.timeago.js"
  javascriptTag "/_j/jquery.timeago.zh-CN.js"
  coffeescript ->
    $ ->
      $container = $('#item-index')
      $container.imagesLoaded -> $container.masonry itemSelector:'.item'
      $("abbr.timeago").timeago()