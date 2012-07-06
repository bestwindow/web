require './applicationController'
class App.GhostsController extends App.ApplicationController
  @param "email"
  @param "name"
  @param "user"

  @beforeAction (next)->
    __insc @request.user
    switch @action
      when 'admin'  then @loadUser =>@nextUrl @isMaster(),next,'/'
      when 'new'    then @nextUrl @request.user,next,'login'
      when 'create' then next()
      when 'show','index','favoritCreate' then @loadUser ->next()
      else 
        @loadUser =>@nextUrl @request.user && (@isMaster()==true || @isSelf()==true),next,'/'

  @beforeAction App.ApplicationHelper.beforeAction

  admin: ->
    App.Ghost.all (error, ghosts) =>
      @ghosts = ghosts
      @render "index"

  index: ->
    @response.redirect "/ghosts/#{@request.user.id}"

  new: ->
    user=@request.user
    @create {user:user._id,name:user.name,email:user.email}
    
  create: (ghost)->
    if !ghost then return @response.redirect "/"
    App.Ghost.create ghost, (error, resource) =>
      if error then @response.redirect "/register"
      else @response.redirect Tower.urlFor(resource)
    
  show: (ghost)->
    who = @params.id || ghost
    if !App.GhostHelper.isSelf.bind(this,who)() and !@isMaster()
      return @response.redirect "/shells/#{who}"
    @paginate = 
      limit:App.pageLimit
      page:@pagination.current @params.page
      route:"/ghosts/#{who}/page/"
    App.Ghost.find who, (error, resource) =>
      result = (error,items)=>
        items = [items] if !items.push
        @paginate.end = @pagination.end items
        @items = items
        @ghost = resource
        @render "show"
      if !resource then return @response.redirect "/"
      if resource.favorit && resource.favorit.length>0
        App.Item
        .paginate(@paginate)
        .find resource.favorit,result
      else
        result null,[]       
    ###
    who = @params.id || ghost
    if !App.GhostHelper.isSelf.bind(this,who)() and !@isMaster()
      return @response.redirect "/shells/#{who}"
    @paginate = 
      limit:App.pageLimit
      page:@pagination.current @params.page
      route:"/ghosts/#{who}/page/"
    App.Ghost.find who, (error, resource) =>
      if !resource then return @response.redirect "/"
      App.Item
      .paginate(@paginate)
      .where(founder:String resource.id)
      .order('updatedAt',"desc")
      .find (error,items)=>
        @paginate.end = @pagination.end items  
        @items = items
        @ghost = resource
        @render "show"
    ###
    
  edit: ()->
    App.Ghost.find @params.id, (error, resource) =>
      if !resource then return @response.redirect "/"
      @ghost = resource
      @render "edit"
      
  update: ->
    user = @request.user
    App.Ghost.find @params.id, (err, resource) =>
      errorRedirect = (e)=>
        if e then @request.flash 'error',e
        @response.redirect "/ghosts/#{user.id}/edit"
      done = (success)=>
        if success then @request.flash 'success',success
        @response.redirect Tower.urlFor resource 
      updateGhost = (query)=>
        resource.updateAttributes query,()->done '用户信息修改成功'
      updateUser = (query,pass,next)=>
        if @params.ghost.email!='' then query.email = @params.ghost.email
        if @params.ghost.name!='' then query.name = @params.ghost.name
        App.updateUser query,pass,(e)->next e,query
      if err || !@params.ghost then return errorRedirect()
      if !@params.ghost.password
        if user.email ==@params.ghost.email && user.name ==@params.ghost.name then return done()
        return updateUser {id:user.user},false,(e,q)->
          delete q.id
          if e then error e else updateGhost q
      if @params.ghost.oldpassword=='' then error '修改密码时需要先输入旧密码'
      else 
        updateUser {login:user.email,password:@params.ghost.password},@params.ghost.oldpassword,(e,q)->
          ['login','password'].forEach (el)->delete q[el]
          if e then error e else updateGhost q
                         

  destroy: ->
    App.Ghost.find @params.id, (error, resource) =>
      if error
        @redirectTo "index"
      else
        resource.destroy (error) =>
          @redirectTo "index"        
          
  favoritCreate: ->
    user = @request.user
    return @resultJson true  if !@params.id
    App.Ghost.find user.id, (err, resource) =>
      q = {}
      q.favorit =  resource.favorit || []
      if q.favorit.length>0
        for el in q.favorit
          return @resultJson true if String(el) == String @params.id         
      q.favorit.push @params.id
      resource.updateAttributes q,(error)=>@resultJson error || null
  favoritDestroy:->
    user = @request.user
    return @resultJson true if !@params.id
    App.Ghost.find user.id, (err, resource) =>
      q = {}
      q.favorit =  resource.favorit || []
      if q.favorit.length>0
        for i in [0..q.favorit.length-1]
          if String(q.favorit[i]) == String @params.id
            q.favorit.splice i,1
            break
      else
        @resultJson null 
      resource.updateAttributes q,(error)=>@resultJson error || null
  resultJson :(error) ->
    @response.writeHead 200, {'Content-Type':'text/plain'}
    @response.end JSON.stringify result:error
    
    
    
    
    
