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
          a href:"#",onclick:"void((function(s,d,e,r,l,p,t,z,c){var f='http://v.t.sina.com.cn/share/share.php',u=z||d.location,p=['?url=',e(u),'&title=',e(t||d.title),'&source=',e(r),'&sourceUrl=',e(l),'&content=',c||'gb2312','&pic=',e(p||'')].join('');function a(){var _url=[f,p].join('');if(!window.open(_url,'mb',['toolbar=0,status=0,resizable=1,width=600,height=460,left=',(s.width-600)/2,',top=',(s.height-460)/2].join('')))u.href=_url;};if(/Firefox/.test(navigator.userAgent))setTimeout(a,0);else a();})(screen,document,encodeURIComponent,'','','http://www.#{Tower.domain}/image/#{item.picture}_5.jpg','#{encodeURIComponent item.text.substr(0,40)}','http://www.#{Tower.domain}/items/#{item.id}','utf-8'));return false",->"分享"
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