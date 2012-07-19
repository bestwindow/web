contentFor "title", "Item #{@item.toLabel()}"
javascriptTag "/_j/ghost.js"
script ->
  if @request.user && @request.user.favorit && @request.user.favorit.length && @request.user.favorit.length>0
    text "var favorits = ['#{@request.user.favorit.join('\',\'')}']"
  else
    text "var favorits = []"
it = @item
edit = if App.GhostHelper.isSelf.bind(this,@ghost.id)() then true else false
if edit
  div class:"page-title",->
    text "商品详情"
    a href:"/items/#{it.id}/edit",->"编辑商品"
else
  div class:"page-title",->"商品详情"

div class:"item-index row-fluid",->
  div class:"item span9",->
    div ->
      a href:"/items/#{it.id}",->
        img src:"/image/#{it.picture}_5.jpg"
    div class:"html", ->
      it.html
    div class:"operation",->
      span class:"price", ->"￥#{it.price}"
      a href:"#{it.link}",target:"_blank",->"购买"
      a class:"favorits",id:"favorit-#{it.id}",href:"#",onclick:"favorit.toggle(event);return false",->"收藏"
      a href:"#",onclick:"void((function(s,d,e,r,l,p,t,z,c){var f='http://v.t.sina.com.cn/share/share.php',u=z||d.location,p=['?url=',e(u),'&title=',e(t||d.title),'&source=',e(r),'&sourceUrl=',e(l),'&content=',c||'gb2312','&pic=',e(p||'')].join('');function a(){var _url=[f,p].join('');if(!window.open(_url,'mb',['toolbar=0,status=0,resizable=1,width=600,height=460,left=',(s.width-600)/2,',top=',(s.height-460)/2].join('')))u.href=_url;};if(/Firefox/.test(navigator.userAgent))setTimeout(a,0);else a();})(screen,document,encodeURIComponent,'','','http://www.#{Tower.domain}/image/#{it.picture}_5.jpg','#{encodeURIComponent(it.text.substr(0,100).replace(/\#/g,'')+'(来自guo.fm)')}','http://www.#{Tower.domain}/items/#{it.id}','utf-8'));return false",->"分享"
      span class:"pull-right",->
        chunkString = ["相似品味的"]
        chunkString.push "<a href=/chunks/#{chunk.path}>#{chunk.title}</a>" for chunk in it.chunk
        text chunkString.join '&nbsp;'

    recommendHtml = []
    if it.recommend
      for i in [0..it.recommend.length-1]
        el = it.recommend[i]
        if el
          recommendHtml.push ck.render (->
            item = this
            div class:"span4",->
              div class:"item_picture",->
                a href:"/items/#{item.get('id')}", ->
                  img src:"/image/#{item.get('picture')}_1.jpg"
              div class:"html", ->
                item.text.split("\r\n")[0]
              div class:"operation",->
                span class:"price", ->"￥#{item.price}"
                text "&nbsp;"
                a href:"#{item.link}",target:"_blank",->"购买"
                text "&nbsp;"
                a class:"favorits",id:"favorit-#{item.id}",href:"#",onclick:"favorit.toggle(event);return false",->"收藏"
                text "&nbsp;"
                a href:"#",onclick:"void((function(s,d,e,r,l,p,t,z,c){var f='http://v.t.sina.com.cn/share/share.php',u=z||d.location,p=['?url=',e(u),'&title=',e(t||d.title),'&source=',e(r),'&sourceUrl=',e(l),'&content=',c||'gb2312','&pic=',e(p||'')].join('');function a(){var _url=[f,p].join('');if(!window.open(_url,'mb',['toolbar=0,status=0,resizable=1,width=600,height=460,left=',(s.width-600)/2,',top=',(s.height-460)/2].join('')))u.href=_url;};if(/Firefox/.test(navigator.userAgent))setTimeout(a,0);else a();})(screen,document,encodeURIComponent,'','','http://www.#{Tower.domain}/image/#{item.picture}_5.jpg','#{encodeURIComponent(item.text.substr(0,100).replace(/\#/g,'')+'(来自guo.fm)')}','http://www.#{Tower.domain}/items/#{item.id}','utf-8'));return false",->"分享"
          ),el
        if (i+1)%3 is 0 or (it.recommend.length<3 and i is it.recommend.length-1)
          div class:"recommend-index row-fluid",->
            text recommendHtml.join ''
          recommendHtml=[]