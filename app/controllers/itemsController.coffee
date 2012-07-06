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
      
  getChunk:(chunks,id)->
    for el in chunks
      return el if id == chunks._id
    null
  showEdit:(route)->
    errorRedirect = => @response.redirect "/chunks"

    App.Item.find @params.id, (error, resource) =>
      getGhost =  (next)->
        App.Ghost.find resource.founder,(e,ghost)->next e,ghost
      getRecommend = (next)->
        if route is 'edit' or !resource.recommend or resource.recommend.length is 0
          next null,{}
        else
          App.Item.find resource.recommend,(e,recommend)->
            recommend = [recommend] if !recommend.push
            resource.recommend = recommend.shuffle()
            next e,recommend
      render = (e,ghost,recommend)=>
        return errorRedirect() if e
        # Auth to edit
        if route is 'edit' and !App.GhostHelper.isSelf.bind(this,ghost.id)() and !@isMaster() then return errorRedirect()
        @ghost = ghost
        App.ChunkHelper.map resource,(result)=>
          @item = result
          @render route
      if !resource then return errorRedirect()
      v.parallel getGhost,getRecommend,render
         
  index: ->
    App.Chunk.all (error, chunks) =>
      App.Item.paginate(page:1,limit:5).all (error, items) =>
        for el in items
          el.createdAt = App.moment(el.createdAt).format App.iso8601
        @items = items
        @render "index"

  new: ->
    @item = new App.Item
    @website = @params.id
    @render "new"
      
  recommend:(chunks,next)->
    itemsRecommend = []
    adjust = (a)->a.concat [a.shift()]
    staticRecommend = 3
    sizeResult = sizeRecommend = staticRecommend
    findLimit = staticRecommend*staticRecommend
    sameChunkFlag = true
    finder = (fn)->
      chunks = adjust chunks
      tempChunks = [].concat chunks
      query = if sizeRecommend then $size:sizeRecommend else {}
      if sameChunkFlag
        sameChunkFlag=false
        query.$all=tempChunks
      else if sizeRecommend==staticRecommend
        query.$nin=tempChunks.splice 0,1
        query.$all=tempChunks
      else
        query.$in=[tempChunks[0]]
      App.Item
      .limit(findLimit)
      .order('createdAt',-1)
      .where(chunk:query)#.where(chunk:$nin:[String resource.id])
      .find (error,items)->
        return fn null if !items
        for i in [0..items.length-1]
          if i<sizeResult              
            random = parseInt Math.random() * items.length,10
            if i ==0 && sizeResult==staticRecommend
              itemsRecommend.unshift String items[random].id if items[random]
            else
              itemsRecommend.push String items[random].id if items[random]
            items.splice random,1
        fn null   
    waterfall = [finder,finder,finder,finder
      (fn)->
        chunks = [""].concat chunks
        adjust = (a)->
          a.shift()
          a
        sizeRecommend = 1 if sizeRecommend
        fn null
      finder,finder,finder
      ->next itemsRecommend.splice 0,staticRecommend*staticRecommend
    ]
    chunks = chunks.splice 0,sizeRecommend if chunks.length>sizeRecommend
    if chunks.length<sizeRecommend
      waterfall.splice 0,4
      waterfall.splice 1,(sizeRecommend-chunks.length)
      sizeResult = findLimit
      findLimit = findLimit*staticRecommend    
      sizeRecommend = sameChunkFlag = false
    v.waterfall.apply this,waterfall
    
  create:->
    @params.item.founder = @request.user.get('id')
    chunks = @params.item.chunk.split ","
    try
      @recommend [].concat(chunks),(items)=>
        @params.item.recommend = items
        @params.item.chunk=chunks
        App.Item.create @params.item,(error,resource)=>
          if error
            @response.redirect "new"
          else
            @response.redirect Tower.urlFor resource
    catch error
      console.log error
      @response.redirect "new"
  show:  ->
    @showEdit 'show'
  edit: ->
    @showEdit 'edit'
      
  update: ->
    @params.item.chunk = @params.item.chunk.split ","
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
