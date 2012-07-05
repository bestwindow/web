contentFor "title", "Item #{@item.toLabel()}"
javascriptTag "/_j/ghost.js"
script ->
  if @request.user && @request.user.favorit && @request.user.favorit.length && @request.user.favorit.length>0
    text "var favorits = ['#{@request.user.favorit.join('\',\'')}']"
  else
    text "var favorits = []"
item = @item
edit = if App.GhostHelper.isSelf.bind(this,@ghost.id)() then true else false
if edit
  ul class:"breadcrumb",->
    li -> "&nbsp;"
    li class:"pull-right",->
      a href:"/items/#{@item.id}/edit",->"编辑货物"

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
        chunkString = ["相似品位的"]
        chunkString.push "<a href=/chunks/#{chunk.path}>#{chunk.title}</a>" for chunk in item.chunk
        text chunkString.join '&nbsp;'

    recommendHtml = []
    for i in [0..item.recommend.length-1]
      el = item.recommend[i]
      if el
        recommendHtml.push [
          "<div class=span4>"
          "<div>"
          "<a href=/items/#{el.id}><img src=/image/#{el.picture}_2.jpg /></a>"
          "</div>"
          "<div>"
          "#{el.html || el.text}"
          "</div>"
          "</div>"
        ].join ''
      if (i+1)%3 is 0
        div class:"recommend-index row-fluid",->
          text recommendHtml.join ''
        recommendHtml=[]
    
