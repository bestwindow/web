class App.MessagesController extends App.ApplicationController
  @param "body"

  @beforeAction (next)->
    switch @action
      when 'admin' then @loadUser =>@nextUrl @isMaster(),next,'/messages'
      else @loadUser =>@nextUrl @request.user,next,'/login'

  index: ->
    done = (m)=>
      @messages = m
      @render "index"
    @paginate = 
      limit:App.pageLimit
      page:@pagination.current @params.page
      route:'/messages/page/'
    App.Message
    .paginate(@paginate)
    .where(owner:String @request.user.id)
    .order('updatedAt',"desc")
    .find (e, msgs) =>
      @paginate.end = @pagination.end msgs
      if e || msgs.length is 0 then return done {}
      App.Message.relate msgs,'latestItem','Item',(e,messages)=>
        App.Message.relate messages,'with','Ghost',(e,messages)=>
          if !messages.push then messages = [messages]
          done messages

  new: ->    
    getToWhom   =  (next)=>
      App.Ghost.find @params.ghost,(e,toWhom)->next e,toWhom
    getItem     = (next)=>
      App.Item.find (@params.item || 0),(e,item)->next e,item
    render      = (e,toWhom,item)=>
      if e || !toWhom then return @response.redirect "/" 
      @message  = new App.Message
      @to       = toWhom
      @item     = item if item 
      @render "new"
    if !@params.ghost then return @response.redirect "/" 
    v.parallel getToWhom,getItem,render

  create:->
    Message           = App.Message._store.collection()
    updateOption      = safe:true,upsert:true,multi:false
    message           = @params.message
    message.from      = @request.user.attributes.id
    message.to        = App.Message._store.encodeId message.to
    message.createdAt = new Date()
    headTo            = with:message.from,owner:message.to
    headFrom          = with:message.to,owner:message.from
    query             = $push:{messages:message},$set:latest:message.body,updatedAt:message.createdAt,latestItem:message.item || false
    if String(message.to)==String(message.from) then return @response.redirect "/messages"
    App.Ghost.find message.to,(e,to)=>
      if !to.read || isNaN to.read then to.read=0 #delete later~~
      createTo    =  (next)->
        query['$inc'] = read:1
        Message.update headTo,query,updateOption,(e,r1)->next e,r1       
      createFrom  = (next)->
        delete query['$inc']
        Message.update headFrom,query,updateOption,(e,r2)->next e,r2
      notyTo      = (next)->
        to.updateAttributes read:to.read+1,()->next()
      render      = (e,r1,r2,msg)=>
        @response.redirect "/messages" 
      if e || !to then return @response.redirect "/"
      v.parallel createTo,createFrom,notyTo,render

  update:->@create()

  show:  ->
    App.Message.find @params.id, (error, resource) =>
      if resource && App.GhostHelper.isSelf.bind(this,resource.owner.id)()
        done = =>
          @to       = resource.with
          @message  = resource
          @render "show"          
        if resource.read<=0 then return done()
        @request.user.read = @request.user.read-resource.read
        if @request.user.read<0 then @request.user.read = 0
        resource.updateAttributes {read:0}, (error) =>
          @request.user.updateAttributes {read:@request.user.read}, (e)->done()
      else
        @response.redirect "/messages"



  destroy: ->
    console.log "destroy"
    App.Message.find @params.id, (error, resource) =>
      if error
        @response.redirect "index"
      else
        resource.destroy (error) =>
          @response.redirect "index"


