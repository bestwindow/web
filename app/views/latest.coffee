javascriptTag "/_j/ghost.js"

script ->
  if @request.user && @request.user.favorit && @request.user.favorit.length && @request.user.favorit.length>0
    text "var favorits = ['#{@request.user.favorit.join('\',\'')}']"
  else
    text "var favorits = []"
div ->
  for item in @items
    div class:"item-index row-fluid",->
      div class:"item span9",->
        div ->
          a href:"/items/#{item.id}",->
            img src:"/image/#{item.picture}_5.jpg"
        div class:"html", ->
          item.html
        div class:"operation",->
          span class:"price", ->"￥#{item.price}"
          a href:"#{item.link}",target:"_blank",->"购买"
          a class:"favorits",id:"favorit-#{item.id}",href:"#",onclick:"favorit.toggle(event);return false",->"收藏"
          span class:"pull-right",->
            chunkString = ["相似品味的"]
            chunkString.push "<a href=/chunks/#{chunk.path}>#{chunk.title}</a>" for chunk in item.chunk
            text chunkString.join '&nbsp;'
          
      div class:"span3",->
        for recommend in item.recommend
          div class:"recommend",->
            a href:"/items/#{recommend.id}",->
              img src:"/image/#{recommend.picture}_0.jpg"           

partial "shared/paginate"