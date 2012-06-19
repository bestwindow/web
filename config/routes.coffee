Tower.Route.draw ->
  admin = (routeNames)=>
    for i in [0..routeNames.length-1]
      @match "/#{routeNames[i]}/a/",    to: "#{routeNames[i]}#admin", via: "get"
  
  admin ["ghosts","chunks","shells","messages","items"]

  @resources "ghosts"
  @match "/ghosts/:id/page/:page",      to: "ghosts#show",    via: "get"

  @resources "chunks"
  @match "/chunks/:id/page/:page",      to: "chunks#show",    via: "get"
  @match "/chunks/page/:page",          to: "chunks#index",    via: "get"
  #@match "/chunks.:format",             to: "chunks#indexJson",    via: "get"

  @resources "messages"
  @match "/messages/new/:ghost/:item",  to: "messages#new",      via: "get"
  @match "/messages/new/:ghost",        to: "messages#new",      via: "get"
  @match "/messages/page/:page",        to: "messages#index",    via: "get"

  @resources "items"
  @match "/items/new/:id",              to: "items#new",      via: "get"

  @resources "shells"
  @match "/shells/:id/page/:page",      to: "shells#show",    via: "get"

  @match "/image",                      to: "images#create",via: "post"
  @match "/image/:id",                  to: "images#show",via: "get"
  @match "/image/crawlurl",             to: "images#crawlUrl",      via: "post"
  @match "/image/crawl",                to: "images#crawl",      via: "post"
  
  


  @match "/loggedin",                   to: "application#loggedin"
  @match "/registed",                   to: "application#registed"
  @match "/exit",                       to: "application#logout"
  @match "(/book)",                     to: "application#book"
  @match "(/landing)",                  to: "application#landing"
  @match "(/*path)",                    to: "application#index"

