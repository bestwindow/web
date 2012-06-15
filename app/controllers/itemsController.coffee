class App.ItemsController extends App.ApplicationController
  @param "text"
  @param "html"
  @param "picture"
  @param "price"

  @beforeAction (next)->
    switch @action
      when 'admin' then @loadUser =>@nextUrl @isMaster(),next,'/chunks'
      when 'create','new','update','edit' then @loadUser =>@nextUrl @request.user,next,'/chunks'
      else @loadUser next
      
    

  showEdit:(route)->
    error = => @response.redirect "/chunks"

    App.Item.find @params.id, (error, resource) =>
      getGhost =  (next)->
        App.Ghost.find resource.founder,(e,ghost)->next e,ghost
      getChunk = (next)->
        App.Chunk.find resource.chunk,(e,chunk)->next e,chunk
      render = (e,ghost,chunk)=>
        if e then return error()
        # check the right to edit
        if route is 'edit' and !App.GhostHelper.isSelf.bind(this,ghost.id)() and !@isMaster() then return error()
        @ghost = ghost
        @chunk = chunk
        @item = resource
        @render route
      if !resource then return error()
      v.parallel getGhost,getChunk,render
         
  index: ->
    App.Item.paginate(page:1,limit:5).all (error, items) =>
      @items = items
      @render "index"

  new: ->
    App.Chunk.where(path:@params.id).first (error, resource) =>
        @item = new App.Item
        @chunk = resource || {}
        @render "new"
  create:->
    @params.item.founder = @request.user.get('id')
    App.Item.create @params.item,(error,resource)=>
      if error
        @response.redirect "new"
      else
        @response.redirect Tower.urlFor(resource)
  show:  ->
    @showEdit 'show'
  edit: ->
    @showEdit 'edit'
      
  update: ->
    App.Item.find @params.id ,(error, resource) =>
      if error
        @response.redirect "edit"
      else
        resource.updateAttributes @params.item, (error) =>
          @response.redirect Tower.urlFor(resource)

  destroy: ->
    console.log "destroy"
    App.Item.find @params.id, (error, resource) =>
      console.log "@item:"+resource
      if error
        @response.redirect "index"
      else
        resource.destroy (error) =>
          @response.redirect "index"
