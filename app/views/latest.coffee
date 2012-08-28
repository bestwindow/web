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
        div class:"operation",->
          span class:"price", ->"￥#{item.price}"
          a href:"#{item.link}",target:"_blank",->"购买"
          a class:"favorits hide",id:"favorit-#{item.id}",href:"#",onclick:"favorit.toggle(event);return false",->"收藏"
          a href:"#",onclick:"shareBtnClick('#{Tower.domain}','#{item.id}','#{item.picture}','#{item.text.replace(/'/g,"\\\'").replace(/(\n|\r|(\r\n)|(\u0085)|(\u2028)|(\u2029))/g, " ")}');return false",->"分享"
          
      div class:"span3",->
        for recommend in item.recommend
          div class:"recommend",->
            a href:"/items/#{recommend.id}",->
              img src:"/image/#{recommend.picture}_0.jpg",title:recommend.text.split("\r\n")[0]
partial "shared/paginate"
contentFor "bottom", ->
  script ->
    if @request.user && @request.user.favorit && @request.user.favorit.length && @request.user.favorit.length>0
      text "var favorits = ['#{@request.user.favorit.join('\',\'')}']"
    else
      text "var favorits = []"
  