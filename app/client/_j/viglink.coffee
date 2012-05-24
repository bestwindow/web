top.vglnk = api_url: '//api.viglink.com/api',key: '65e1aa234d19550de896cdb5233197ae'

((d, t)->
  s = d.createElement(t)
  s.type = 'text/javascript'
  s.async = true
  s.src = (if 'https:' == document.location.protocol then vglnk.api_url else '//cdn.viglink.com/api') + '/vglnk.js'
  r = d.getElementsByTagName(t)[0]
  r.parentNode.insertBefore(s, r)
)(document, 'script')