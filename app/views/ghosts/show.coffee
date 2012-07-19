javascriptTag "/_j/jquery.masonry.js"
coffeescript ->
  $ ->
    $container = $('#items')
    $container.imagesLoaded -> $container.masonry itemSelector:'.item'

contentFor "title", "Ghost #{@ghost.toLabel()}"
javascriptTag "/_j/ghost.js"

script ->
  if @request.user && @request.user.favorit && @request.user.favorit.length && @request.user.favorit.length>0
    text "var favorits = ['#{@request.user.favorit.join('\',\'')}']"
  else
    text "var favorits = []"


div class:"page-title",->"我的收藏"
div id:"items", =>
  for item in @items
    div class:"item chunk-show",=>
      div class:"item_picture",=>
        a href:"/items/#{item.get('id')}", ->
          img src:"/image/#{item.get('picture')}_1.jpg"
      div class:"html", ->
        item.html
      div class:"operation",->
        span class:"price", ->"￥#{item.price}"
        a href:"#{item.link}",target:"_blank",->"购买"
        a class:"favorits favoriteslist",id:"favorit-#{item.id}",href:"#",onclick:"favorit.toggle(event);return false",->"收藏"
        a href:"#",onclick:"void((function(s,d,e,r,l,p,t,z,c){var f='http://v.t.sina.com.cn/share/share.php',u=z||d.location,p=['?url=',e(u),'&title=',e(t||d.title),'&source=',e(r),'&sourceUrl=',e(l),'&content=',c||'gb2312','&pic=',e(p||'')].join('');function a(){var _url=[f,p].join('');if(!window.open(_url,'mb',['toolbar=0,status=0,resizable=1,width=600,height=460,left=',(s.width-600)/2,',top=',(s.height-460)/2].join('')))u.href=_url;};if(/Firefox/.test(navigator.userAgent))setTimeout(a,0);else a();})(screen,document,encodeURIComponent,'','','http://www.#{Tower.domain}/image/#{item.picture}_5.jpg','#{encodeURIComponent(item.text.substr(0,100).replace(/\#/g,'')+'(来自guo.fm)')}','http://www.#{Tower.domain}/items/#{item.id}','utf-8'));return false",->"分享"
        

partial "shared/paginate"