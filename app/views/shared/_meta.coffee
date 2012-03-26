meta charset: "utf-8"

if hasContentFor "title"
  title @title
else
  title t("title")

meta name: "description", content: t("description")
meta name: "keywords", content: t("keywords")
meta name: "robots", content: t("robots")
meta name: "author", content: t("author")

csrfMetaTag()

appleViewportMetaTag width: "device-width", max: 1, scalable: false

#stylesheets "lib", "vendor", "application"

link rel:"stylesheet",href:"/_c/bootswatch/bootstrap.css"
link rel:"stylesheet",href:"/_c/bootswatch/bootstrap-responsive.css"
link rel:"stylesheet",href:"/_c/fortawesome/css/font-awesome.css"
link rel:"stylesheet",href:"/_c/validation/engine.css"

stylesheets "lib", "application"


link href: "/favicon.png", rel: "icon shortcut-icon favicon"

#if browserIs("firefox")
#  stylesheets "font"

#if contentFor "headStyleSheets"
#  yield "headStyleSheets"

javascriptTag "/_j/jquery.min.js"
  
#if contentFor "headJavaScripts"
#  yield "headJavaScripts"

contentFor "bottom", ->
  javascripts "vendor" 
  if Tower.env == "development"
    javascripts "development"
  javascripts "lib", "application"
