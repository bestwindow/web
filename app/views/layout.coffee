doctype 5
html ->
  head ->
    meta charset: 'utf-8'
  
    title "guo.fm 果味调频"
  
    link rel: 'icon', href: '/favicon.png'
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

    header id: "header", class: "header", role: "banner", ->
      div class: "container", ->
        partial "shared/_header"

    section id: "content", role: "main", =>
      div class: "container", =>
        @body

    footer id: "footer", class: "footer", role: "contentinfo", ->
      div class: "container", ->
        partial "shared/_footer"
