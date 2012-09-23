div class:"page-title"
div ->
  for item in @items
    div class:"item-index row-fluid",->
      div class:"item span9",->
        div class:"img", ->
          a href:"/items/#{item.id}",->
            img src:"/image/#{item.picture}_5.jpg",title:item.text.split("\r\n")[0]
        div class:"html", ->
          item.html
partial "shared/paginate"
  