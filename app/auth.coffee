mongoose= require "mongoose"
db = require('../config/databases.coffee').mongodb[Tower.env]
mongoose.connect "mongodb://#{db.host}/#{db.name}"
Schema = mongoose.Schema
mongooseAuth = require "mongoose-auth"
UserSchema = new Schema {}
UserSchema.plugin mongooseAuth,
  everymodule:
    everyauth:
      User: ->User
  password:
    loginWith: "email"
    extraParams:
      name: type:String,index:unique:true
    everyauth:
      getLoginPath: "/login"
      postLoginPath: "/login"
      loginView: "login.coffee"
      getRegisterPath: "/register"
      postRegisterPath: "/register"
      registerView: "register.coffee"
      loginSuccessRedirect: "/loggedin"
      registerSuccessRedirect: "/registed"

mongoose.model "User", UserSchema
User = mongoose.model "User"
exports.mongooseAuth = mongooseAuth
exports.authenticate = (login,pass,fn)->User.authenticate login,pass,fn

exports.updateUser = (user,pass,fn)->
  update = (u)->
    if user.email then u.email = user.email
    if user.name then u.name = user.name
    u.save (err=null)->fn err,u
  if pass
    User.authenticate user.login,pass,(e,u)->
      if !u then return fn '用户密码错误'
      else
        u.password = user.password
        update u
  else
    User.findById user.id,(e,u)->
      if !u then return fn '没有这个用户'
      else update u





LoginToken = new Schema
  email:
    type: String
    index: true
  series:
    type: String
    index: true
  token:
    type: String
    index: true

LoginToken.method "randomToken", ->
  "#{ Math.round((new Date().valueOf() * Math.random())) }"

LoginToken.pre "save", (next)->
  console.log "@isNew:#{@isNew}"
  @token = @randomToken()
  @series = @randomToken()  if @isNew
  next()

LoginToken.virtual("id").get ->
  @_id.toHexString()

LoginToken.virtual("cookieValue").get ->
  JSON.stringify
    email: @email
    token: @token
    series: @series
mongoose.model "LoginToken", LoginToken
LoginToken = mongoose.model "LoginToken"

exports.deleteSession = deleteSession = (req,res,next)->
  if req.session && req.session.auth
    LoginToken.remove { email: req.user.email },->
      res.clearCookie 'logintoken'
      delete req.user
      req.session.destroy ->
        next()
  else
    next()

exports.createSession = createSession = (req, res, next) ->
  console.log "exports.createSession!!!!"
  if req.user
    loginToken = new LoginToken(email:req.user.email)
    loginToken.save ->
      res.cookie "logintoken", loginToken.cookieValue,
        expires: new Date(Date.now() + 1024 * 604800000)
        path: "/"
        domain:".#{Tower.domain}"
      next()
  else
    res.redirect "/login"


authenticateByLoginToken = (proxy,req, res, next) ->
  cookie = JSON.parse(req.cookies.logintoken)
  LoginToken.findOne
    email: cookie.email
    series: cookie.series
    token: cookie.token
  , (err, token) ->
    return next() unless token
    proxy token.email,(err, userPlus) ->
      if userPlus
        req.session.auth = {userId:userPlus.user,loggedIn:true}
        req.user = userPlus
        token.token = token.randomToken()
        token.save ->
          res.cookie "logintoken", token.cookieValue,
            expires: new Date(Date.now() + 1024 * 604800000)
            path: "/"
            domain:".#{Tower.domain}"
          next()
      else
        delete req.user
        next()

exports.loadUser = loadUser = (proxy,req,res,next) ->
  #console.log "auth.coffee loadUser:"+(req.session.auth && req.session.auth.userId)
  if (authSessionFound=->req.session.auth && req.session.auth.userId)()
    proxy req.session.auth.userId, (err, userPlus) =>
      if userPlus then req.user = userPlus else delete req.user
      next()
  else if (logintokenCookieFound=->req.cookies.logintoken)()
    authenticateByLoginToken proxy,req, res, next
  else
    delete req.user
    next()


