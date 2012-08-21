
window.shareBtnClick = function(domain, itemId, itemPicture, itemText) {
  return (function(s, d, e, r, l, p, t, z, c) {
    var f, u, windowOpen;
    f = 'http://v.t.sina.com.cn/share/share.php';
    u = z || d.location;
    p = ['?url=', e(u), '&title=', e(t || d.title), '&source=', e(r), '&sourceUrl=', e(l), '&content=', c || 'gb2312', '&pic=', e(p || '')].join('');
    windowOpen = function() {
      var _url;
      _url = [f, p].join('');
      if (!window.open(_url, 'mb', ['toolbar=0,status=0,resizable=1,width=600,height=460,left=', (s.width - 600) / 2, ',top=', (s.height - 460) / 2].join(''))) {
        return u.href = _url;
      }
    };
    if (/Firefox/.test(navigator.userAgent)) {
      return setTimeout(windowOpen, 0);
    } else {
      return windowOpen();
    }
  })(screen, document, encodeURIComponent, '', '', "http://www." + domain + "/image/" + itemPicture + "_5.jpg", encodeURIComponent(itemText.substr(0, 100).replace(/\#/g, '') + '(guo.fm)'), "http://www." + domain + "/items/" + itemId, 'utf-8');
};
