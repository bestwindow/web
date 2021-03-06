class App.ApplicationController extends Tower.Controller
  @layout "application"

  isMaster:->
    ['engineer','webmaster'].indexOf(App.GhostHelper.responsibility.bind(this)())>=0
  isSelf:-> 
    App.GhostHelper.isSelf.bind(this,@params.id)()
  nextUrl:(bool,next,url)->
    if bool then next() else @response.redirect url
  loadUser:(next)->
    App.loadUser App.GhostHelper.findGhost,@request,@response, =>next()    
  pagination:
    current:(page)->((p)->if isNaN p then 1 else p) parseInt page,10
    end:(source)->if source and source.length is 0 then true else false

  post:->
    console.log "post"
    console.log @params
    @response.writeHead 200, {'Content-Type':'text/plain'}
    @response.end "YES"
  registed: ->
    App.createSession @request,@response,()=>
      @response.redirect "/ghosts/new"
  loggedin: ->
    App.createSession @request,@response,()=>
      @response.redirect "/"
  logout: ->
    App.deleteSession @request,@response,()=>
      @response.redirect "/"
  aboutus: ->
    App.loadUser App.GhostHelper.findGhost,@request,@response,=>
      @render "aboutus"
  preview: ->
    it = @params.item
    item = new App.Item
    item.id = 0
    for el in ["text","html","chunk","picture","link","price"]
      item[el] = it[el]
    item.chunk = item.chunk.split ','
    item.recommend = []
    @index item
  index: (previewItem)->
    App.loadUser App.GhostHelper.findGhost,@request,@response,=>
      @paginate = 
      limit:App.pageLimit
      page:@pagination.current @params.page
      route:"/page/" 
      App.Item.order('createdAt',-1).paginate(@paginate).all (error, items)=>
        if previewItem then items.unshift previewItem
        @paginate.end = @pagination.end items
        App.ChunkHelper.map items,(data)=>
          for el in data
            el.createdAt = App.moment(el.createdAt).format App.iso8601
          @items = data
          @render "latest"
  landing:->
    @render "index"    
  book: ->
    App.loadUser App.GhostHelper.findGhost,@request,@response,=>
      #@render "index"
      App.Item.order('createdAt',-1).paginate(page:1,limit:100).all (error, items)=>
        for i in [0..items.length-1]
          items.createdAt = App.moment(items.createdAt).format App.iso8601
        @items = items
        @render "book"



    ###
    class App.ChunksController extends App.ApplicationController
  @param "title"
  @param "path"

  @beforeAction (next)->
    App.loadUser App.GhostHelper.findGhost,@request,@response,()=>
      if @request.user then next() else @response.redirect '/login'

  index: ->
    App.Chunk.paginate(page:1,limit:5).all (error, chunks) =>
      __insc chunks
      @chunks = chunks
      @render "index"

  new: ->
    @chunk = new App.Chunk
    @render "new"

  create:->
    @params.chunk.founder = @request.user.attributes.user
    App.Chunk.create @params.chunk,(error,resource)=>
      if error
        @response.redirect "new"
      else
        @response.redirect Tower.urlFor(resource)

  show:  ->
    App.Chunk.find @params.id, (error, resource) =>
      if resource
        @chunk = resource
        @render "show"
      else
        @response.redirect "index"

  edit: ->
    App.Chunk.find @params.id, (error, resource) =>
      if resource
        @chunk = resource
        @render "edit"
      else
        @response.redirect "index"
      
  update: ->
    App.Chunk.find @params.id ,(error, resource) =>
      if error
        @response.redirect "edit"
      else
        resource.updateAttributes @params.chunk, (error) =>
          @response.redirect Tower.urlFor(resource)

  destroy: ->
    console.log "destroy"
    App.Chunk.find @params.id, (error, resource) =>
      console.log "@chunk:"+resource
      if error
        @response.redirect "index"
      else
        resource.destroy (error) =>
          @response.redirect "index"
    ###
