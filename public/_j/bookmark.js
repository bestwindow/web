(function() {
  var f_url, imageList, lo;

  window.fm = document.createElement('form');

  imageList = (function() {
    var amazoneImageDomain, image, imageArray, imageSizeStr, imageStr, res, script, scriptDom, _i, _len;
    res = [];
    if (window.location.href.indexOf('amazon.com') >= 0) {
      amazoneImageDomain = "http://ecx.images-amazon.com/images/";
      imageSizeStr = "1500_.jpg";
      scriptDom = document.getElementsByTagName('script');
      script = (function() {
        var a, i, _i, _len;
        a = [];
        for (_i = 0, _len = scriptDom.length; _i < _len; _i++) {
          i = scriptDom[_i];
          a.push(i.innerHTML);
        }
        return a.join('');
      })();
      imageArray = script.split(amazoneImageDomain).splice(1);
      for (_i = 0, _len = imageArray.length; _i < _len; _i++) {
        imageStr = imageArray[_i];
        image = "" + amazoneImageDomain + (imageStr.split('.jpg')[0]) + ".jpg";
        if (image.indexOf(imageSizeStr) > 0 && image.indexOf('"') < 0 && image.indexOf("'") < 0) {
          res.push(image);
        }
      }
      return res.join('');
    }
    return "";
  })();

  fm.method = 'post';

  lo = top.location + imageList;

  fm.action = "http://" + (window.guofmDomain.indexOf('localhost') >= 0 ? '' : 'www.') + window.guofmDomain + "/items/new";

  fm.target = window.guofmDomain;

  f_url = document.createElement('input');

  f_url.type = 'hidden';

  f_url.name = 'url';

  f_url.value = encodeURIComponent(lo).replace(/\\./g, '~');

  fm.appendChild(f_url);

  document.body.appendChild(fm);

  fm.submit();

}).call(this);
