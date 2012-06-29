contentFor "title", "Item #{@item.toLabel()}"


edit = if App.GhostHelper.isSelf.bind(this,@ghost.id)() then true else false
ul class:"breadcrumb",=>
  li ->
    a href:'/', '首页'
    span class:"divider",'/'
  if edit
    li class:"pull-right",=>
      a href:"/items/#{@item.id}/edit",->"编辑货物"


div class:"content row",id:"itemshow",=>
  div class:"span7",=>
    div class:"picture", =>
      img src:"/image/#{@item.picture}_5.jpg",style:"border:20px solid white"
  div class:"span5",=>
    div class:"hero-unit",=>
      div (@item.html || @item.text)
      div "&nbsp;"
      h3 "价格:￥ #{@item.get('price')}"
      a class:"btn btn-warning btn-large", href:"#{@item.link}",target:"_blank",=>"购买"

for item in @item.recommend
  div ->
    img src:"/image/#{item.picture}_2.jpg"
  div ->
    (item.html || item.text)
