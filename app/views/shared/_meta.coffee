meta charset: "utf-8"

title "the web title"

meta name: "description", content: t("description")
meta name: "keywords", content: t("keywords")
meta name: "robots", content: t("robots")
meta name: "author", content: t("author")
meta name: "HandheldFriendly", content: "True"

csrfMetaTag()

#appleViewportMetaTag width: "device-width", max: 1, scalable: false

#stylesheets "lib", "vendor", "application"

cssPath = if Tower.stylesheet then "#{Tower.stylesheet}/" else ""
link rel:"stylesheet",href:"/_c/bootswatch/#{cssPath}bootstrap.css"
link rel:"stylesheet",href:"/_c/bootswatch/bootstrap-responsive.css"
link rel:"stylesheet",href:"/_c/fortawesome/css/font-awesome.css"
link rel:"stylesheet",href:"/_c/validation/engine.css"
link rel:"stylesheet",href:"/stylesheets/app/client/stylesheets/application.css"
#stylesheets "lib", "application"


link href: "/favicon.png", rel: "icon shortcut-icon favicon"