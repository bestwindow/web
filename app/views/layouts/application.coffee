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
        
    javascriptTag "/_j/jquery.min.js"
    javascriptTag "/_j/jquery.cookie.js"
    javascriptTag "/_j/ghost.js" 
    if hasContentFor "bottom"
      yields "bottom"
    jsname = "transition,alert,modal,dropdown,scrollspy,tab,tooltip,popover,button,collapse,carousel,typeahead"
    jsname.split(',').forEach (el)->
      javascriptTag "/javascripts/vendor/javascripts/bootstrap/bootstrap-#{el}.js"
    
    #http://www.viglink.com/
    div class:"hide",-> javascriptTag "http://s25.cnzz.com/stat.php?id=4369109&web_id=4369109"
    javascriptTag '/_j/viglink.js'  

  if hasContentFor "popups"
    aside id: "popups", ->
      yields "popups"
      

    

