require '../app_config.coffee'
global.__insc = (s)->console.log require('util').inspect(s)
global.v      = require 'valentine'
global.ck     = require 'coffeekup'
fs            = require 'fs'
auth          = require '../app/auth'
mongooseAuth  = auth.mongooseAuth
mongoStore    = require 'connect-mongodb'
moment        = require 'moment'

mongodb = (->
  dbConfig      = require('./databases').mongodb[Tower.env]
  Db            = require('mongodb').Db
  Server        = require('mongodb').Server
  server_config = new Server dbConfig.host,dbConfig.port,
    auto_reconnect: true
    native_parser: true
  new Db dbConfig.name, server_config, {}
)()


class App extends Tower.Application
  @configure ->  
    @server.set 'views', './app/views' #for mongooseAuth 1/2
    #@server.set 'view engine', 'coffee'
    @server.register ".coffee", ck.adapters.express # register engine with given extension 
    @server.set "view engine", 'coffeekup' # view engine for everyauth
    
    @use "favicon", Tower.publicPath + "/favicon.ico"
    @use "static",  Tower.publicPath, maxAge: Tower.publicCacheDuration
    @use "profiler" if Tower.env != "production"
    @use "logger"
    @use "query"
    @use "cookieParser", Tower.cookieSecret
    @use "session", 
      secret: Tower.sessionSecret
      store: new mongoStore {db:mongodb}#Tower.Store.MongoDB.database#}
    @use "bodyParser"
    #@use "csrf"
    @use "methodOverride", "_method"
    @use Tower.Middleware.Agent
    @use Tower.Middleware.Location
    @use mongooseAuth.middleware() #mongooseAuth 2/2
    @use Tower.Middleware.Router
    @deleteSession  = auth.deleteSession
    @createSession  = auth.createSession
    @authenticate   = auth.authenticate
    @updateUser     = auth.updateUser
    @loadUser       = auth.loadUser
    @moment         = moment
    @sanitizer      = require "sanitizer"
    @iso8601        = 'YYYY-MM-DDTHH:mm:ss'
    @pageLimit      = 12

    Tower.Store.MongoDB.config = Tower.config.databases.mongodb
    Tower.Store.MongoDB.initialize ->
      console.log("Tower.Store.MongoDB.database:"+Tower.Store.MongoDB.database)



Tower.imageSize = (type)->
  imageArray = 
    type:['picture','avatar','blog']
    item:[100,220,500,820]
    blog:[100,200,300,400,480,700,960]
    avatar:[50,100,180,480,700]
    background:[0]
  imageArray[type]
Tower.imageSize.max = (type)->Tower.imageSize(type).length-1


module.exports = global.App = new App
towermod = require '../app/towermod'

#some helper
Array.prototype.shuffle = ->
  s = []
  s.push @splice(Math.random() * @length, 1)[0] while @length
  @push s.pop() while s.length
  this

compileClient = ->
  stylus = require('stylus')
  cs = require("coffee-script")
  jsSourceDir = "app/client/_j/" 
  cssSourceDir = "app/client/stylesheets/" 
  for file in ((fs.readdirSync jsSourceDir).concat fs.readdirSync cssSourceDir)
    if file.match /\.(coffee)$/
      fs.writeFileSync "public/_j/#{file.replace(/\.(coffee)$/,'.js')}",cs.compile fs.readFileSync "#{jsSourceDir}#{file}","utf-8"
    if file.match /\.(styl)$/      
      stylus.render fs.readFileSync("#{cssSourceDir}#{file}","utf-8"),(err,cssStr)->
        if err then console.log "stylus compile error: #{err}"
        fs.writeFileSync "public/stylesheets/app/client/stylesheets/#{file.replace(/\.(styl)$/,'.css')}",cssStr
compileClient()







