meta charset: "utf-8"

###
if hasContentFor "title"
  title @title
else
  title t("title")
###
title "a demo"

meta name: "description", content: t("description")
meta name: "keywords", content: t("keywords")
meta name: "robots", content: t("robots")
meta name: "author", content: t("author")

csrfMetaTag()

appleViewportMetaTag width: "device-width", max: 1, scalable: false

#stylesheets "lib", "vendor", "application"

cssPath = if Tower.stylesheet then "#{Tower.stylesheet}/" else ""
link rel:"stylesheet",href:"/_c/bootswatch/#{cssPath}bootstrap.css"
link rel:"stylesheet",href:"/_c/bootswatch/bootstrap-responsive.css"
link rel:"stylesheet",href:"/_c/fortawesome/css/font-awesome.css"
link rel:"stylesheet",href:"/_c/validation/engine.css"
link rel:"stylesheet",href:"/stylesheets/app/client/stylesheets/application.css"
#stylesheets "lib", "application"


link href: "/favicon.png", rel: "icon shortcut-icon favicon"

#if browserIs("firefox")
#  stylesheets "font"

#if contentFor "headStyleSheets"
#  yield "headStyleSheets"

javascriptTag "/_j/jquery.min.js"
  
#if contentFor "headJavaScripts"
#  yield "headJavaScripts"

contentFor "bottom", ->
  jsname = "transition,alert,modal,dropdown,scrollspy,tab,tooltip,popover,button,collapse,carousel,typeahead"
  jsname.split(',').forEach (el)->
    javascriptTag "/javascripts/vendor/javascripts/bootstrap/bootstrap-#{el}.js"
  
  #http://www.viglink.com/
  javascriptTag '/_j/viglink.js'

  ###
  javascripts "vendor" 
  if Tower.env == "development"
    javascripts "development"
  javascripts "lib", "application"
  ###
