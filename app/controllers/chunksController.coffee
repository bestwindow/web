class App.ChunksController extends App.ApplicationController
  @param "title"
  @param "path"

  @beforeAction (next)->
    switch @action
      when 'admin' then @loadUser =>@nextUrl @isMaster(),next,'/chunks'
      when 'create','new','update','edit' then @loadUser =>@nextUrl @request.user,next,'/chunks'
      else @loadUser next

  admin: ->
    App.Chunk.paginate(page:1,limit:100).all (error, chunks) =>
      @chunks = chunks
      @render "admin"

  index: ->
    App.Chunk.paginate(page:1,limit:100).all (error, chunks) =>
      @paginate = 
        limit:App.pageLimit
        page:@pagination.current @params.page
        route:"/chunks/page/" 
      App.Item
      .paginate(@paginate)
      .order('createdAt',"desc")
      .find (error,items)=>
        @chunks = chunks
        @paginate.end = @pagination.end items 
        @items = items
        @render "index"

  new: ->
    @chunk = new App.Chunk
    @render "new"

  create:->
    chunk = @params.chunk
    chunk.founder = @request.user.attributes.user
    chunk.path = @params.chunk.path.toLowerCase().trim()
    chunk.title = chunk.title.trim()
    App.Chunk.create chunk,(error,resource)=>
      if error
        @response.redirect "/chunks/new"
      else
        @response.redirect "/chunks"

  show:  ->
    App.Chunk.where(path:@params.id).first (error, resource) =>
      if resource
        @chunk = resource
        @paginate = 
          limit:App.pageLimit
          page:@pagination.current @params.page
          route:"/chunks/#{@params.id}/page/" 
        App.Item
        .paginate(@paginate)
        .where(chunk:String resource.id)
        .order('createdAt',"desc")
        .find (error,items)=>
          @paginate.end = @pagination.end items     
          @items = items
          @render "show"
      else
        @response.redirect "/chunks"

  edit: ->
    App.Chunk.find @params.id, (error, resource) =>
      if resource
        @chunk = resource
        @render "edit"
      else
        @response.redirect "/chunks"
      
  update: ->
    App.Chunk.find @params.id ,(error, resource) =>
      if error
        @response.redirect "/chunks/#{@params.id}/edit"
      else
        resource.updateAttributes @params.chunk, (error) =>
          @response.redirect "/chunks/#{@params.id}"

  destroy: ->
    console.log "destroy"
    App.Chunk.find @params.id, (error, resource) =>
      console.log "@chunk:"+resource
      if error
        @response.redirect "/chunks"
      else
        resource.destroy (error) =>
          @response.redirect "/chunks"

