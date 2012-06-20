div ->
  for item in @items
    div class:"item-index row-fluid",->
      div class:"span9",->
        div ->
          img src:"/image/#{item.picture}_5.jpg"
        div class:"html", ->
          item.html
        div class:"operation",->
          span class:"price", ->"￥#{item.price}"
          a href:"#{item.link}",target:"_blank",->"购买"
          
      div class:"span3",->
        div style:"width:80px;height:100px;background:gray;margin:8px 0px;",->"&nbsp;"
        div style:"width:80px;height:100px;background:gray;margin:8px 0px;",->"&nbsp;"
        div style:"width:80px;height:100px;background:gray;margin:8px 0px;",->"&nbsp;"

partial "shared/paginate"