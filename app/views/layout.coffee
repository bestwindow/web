doctype 5
html ->
  head ->
    meta charset: 'utf-8'
  
    title "未命名"
  
    link rel: 'icon', href: '/favicon.ico'
    link rel: 'stylesheet', href: '/_c/bootswatch/bootstrap.css'
    link rel: 'stylesheet', href: '/_c/bootswatch/bootstrap-responsive.css'
    link rel: 'stylesheet', href: '/_c/fortawesome/css/font-awesome.css'
    link rel: 'stylesheet', href: '/_c/validation/engine.css'
    link rel: 'stylesheet', href: '/stylesheets/app/client/stylesheets/application.css'

  body role: "application", =>  
    script src: '/_j/jquery.min.js'
    script src: '/_j/jquery.validationEngine-zh_CN.js'
    script src: '/_j/jquery.validationEngine.js'
    script src: '/_j/auth.js'  
    partial "shared/_navigation"

    div class: "container", =>
      @body

    div id: "footer", class: "footer", role: "contentinfo", ->
      div class: "container", ->
        partial "shared/_footer"
