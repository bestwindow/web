doctype 5
html ->
  head ->
    partial "shared/meta"
  
  body role: "application", ->
    #if browserIs "ie"
    #  javascriptTag "http://html5shiv.googlecode.com/svn/trunk/html5.js"
      
    if hasContentFor "templates"
      yields "templates"
      
    partial "shared/navigation"
        
    header id: "header", class: "header", role: "banner", ->
      div class: "container", ->
        partial "shared/header"
        
    section id: "content", role: "main", ->
      div class: "container", ->
        partial "shared/flash"
        yields "body"
        aside id: "sidebar", role: "complementary", ->
          if hasContentFor "sidebar"
            yields "sidebar"
            
    footer id: "footer", class: "footer", role: "contentinfo", ->
      div class: "container", ->
        partial "shared/footer"
        
  if hasContentFor "popups"
    aside id: "popups", ->
      yields "popups"
      
  if hasContentFor "bottom"
    yields "bottom"
