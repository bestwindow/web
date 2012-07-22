window.fm = document.createElement 'form'
imageList = (->
  res = []
  if window.location.href.indexOf('amazon.com')>=0
    amazoneImageDomain = "http://ecx.images-amazon.com/images/"
    imageSizeStr = "1500_.jpg"
    scriptDom = document.getElementsByTagName 'script'
    script = (->
      a = []
      for i in scriptDom then a.push i.innerHTML
      a.join ''
    )()
    imageArray = script.split(amazoneImageDomain).splice 1
    for imageStr in imageArray
      image = "#{amazoneImageDomain}#{imageStr.split('.jpg')[0]}.jpg"
      if image.indexOf(imageSizeStr)>0 && image.indexOf('"')<0 && image.indexOf("'")<0
        res.push image
    return res.join ''
  ""
)()
fm.method='post'
lo = top.location+imageList
fm.action="http://#{if window.guofmDomain.indexOf('localhost')>=0 then '' else 'www.'}#{window.guofmDomain}/items/new"
fm.target=window.guofmDomain;
f_url = document.createElement 'input'
f_url.type = 'hidden'
f_url.name = 'url'
f_url.value = encodeURIComponent(lo).replace /\\./g,'~'
fm.appendChild f_url
document.body.appendChild fm
fm.submit()