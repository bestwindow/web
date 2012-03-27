require '../app_config.coffee'
global.__insc = (s)->console.log require('util').inspect(s)
global.v      = require 'valentine'
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
    @pageLimit      = 10

    Tower.Store.MongoDB.config = Tower.config.databases.mongodb
    Tower.Store.MongoDB.initialize ->
      console.log("Tower.Store.MongoDB.database:"+Tower.Store.MongoDB.database)


Tower.domain='b1lou'
Tower.imageSize = (type)->
  imageArray = 
    type:['picture','avatar','blog']
    item:[100,192,200,300,400,500,600,960]
    blog:[100,200,300,400,500,600,960]
    avatar:[50,100,180,500]
    background:[0]
  imageArray[type]
Tower.imageSize.max = (type)->Tower.imageSize(type).length-1


module.exports = global.App = new App
towermod = require '../app/towermod'


compileClient = ->
  cs = require("coffee-script")
  sourceDir = "app/client/_j/" 
  for file in (fs.readdirSync sourceDir)
    if file.match /\.(coffee)$/
      fs.writeFileSync "public/_j/#{file.replace(/\.(coffee)$/,'.js')}",cs.compile fs.readFileSync "#{sourceDir}#{file}","utf-8"
compileClient()


