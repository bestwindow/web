class App.ShellsController extends App.ApplicationController
  @param "email"
  @param "name"
  @param "user"

  @beforeAction (next)->
    switch @action
      when 'admin' then @loadUser =>@nextUrl @isMaster(),next,'/'
      else @loadUser next

 
  admin: ->
    App.Ghost.all (error, resource) =>
      @ghosts = resource
      @render "index"
  
  index:->
    @response.redirect "/shells/#{@request.user.id}"
    
  show:  (ghost)->
    who = @params.id || ghost
    @paginate = 
      limit:App.pageLimit
      page:@pagination.current @params.page
      route:"/shells/#{who}/page/"
    App.Ghost.find who, (error, resource) =>
      if !resource then return @response.redirect "/"
      App.Item
      .paginate(@paginate)
      .where(founder:String resource.id)
      .order('createdAt',"desc")
      .find (error,items)=>
        @paginate.end = @pagination.end items  
        @items = items
        @ghost = resource
        @render "show"