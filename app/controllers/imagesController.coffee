formidable = require 'formidable'
util = require 'util'
request = require 'request'
jsdom  = require 'jsdom'
fs     = require 'fs'
Iconv  = require('iconv').Iconv
jquery = fs.readFileSync("./public/_j/jquery.min.js").toString()



class App.ImagesController extends App.ApplicationController
  
  crawlHtml=(url,fn)->
    options = url:url,encoding:null
    afterRequest = (error, response, body)->
      gbk_to_utf8_iconv = new Iconv 'GBK', 'UTF-8'
      body = gbk_to_utf8_iconv.convert body
      jsdom.env
        html: body||""
        src: [jquery]
        done:(errors, window)->
          res = images:[]
          $ = window.$
          res.title = escape $("title").html()
          res.price = $('#J_StrPrice').html()
          for i in [].concat($.makeArray $ '#J_UlThumb img')
          .concat($.makeArray $ ".J_TRegion img")
          .concat($.makeArray $ ".tb-shop img")
            el = $ i
            if el.attr('src').indexOf(".jpg")>0
              res.images.push "#{el.attr('src').split('.jpg')[0]}.jpg"
            else
              res.images.push el.attr('src').split('?')[0]
          fn res
    try
      request options,afterRequest
    catch error
      fn []
    
  crawlImage = (addr,fn)->
    options = {uri:addr,encoding:null,timeout:45000}
    afterRequest = (error, response, body)->
      if !error && response.statusCode == 200
        App.ImageHelper.writeLocal body,addr.replace('http://','').split('/').join('-'),fn
      else
        fn ""      
    try
      request options,afterRequest 
    catch error
      fn ""
  
  formJson = (imageName,type)->
    ###
    cant's use @response.json since IE is dumping on 'application/json':
    https://github.com/blueimp/jQuery-File-Upload/wiki/Setup
    see "Content-Type Negotiation"
    ###
    @response.writeHead 200, {'Content-Type':'text/plain'}
    @response.end JSON.stringify [
      "name":""
      "size":0
      "url":"\/image\/#{imageName}_#{Tower.imageSize.max(type)}.jpg"
      "thumbnail_url":"\/image\/#{imageName}_0.jpg"
      "delete_url":"#"
      "delete_type":"DELETE"
    ]
  
  create:->
    form = new formidable.IncomingForm()
    files = []
    fields = []

    form.uploadDir = '/tmp'
    form
    .on('field',(field, value)=>fields.push [field, value])
    .on('file',(field, file)=>files.push [field, file])
    .on 'end', ()=>
      return @response.json {errorThrown:'no type'} if !fields[0]
      return @response.json {errorThrown:'no file'} if !files[0]
      type = fields[0][1]
      file = files[0][1].path
      App.ImageHelper.write file,type,(imageName)=>formJson.apply this,[imageName,'item']
    form.parse @request
  show:->
    App.ImageHelper.read "#{@request.params.id}.jpg",(fileData)=>
      @response.writeHead 200, {'Content-Type': 'image/jpeg' }
      @response.end fileData, 'binary'
  crawlUrl: ->
    crawlHtml @params.url,(html)=>
      @response.writeHead 200, {'Content-Type':'text/plain'}
      @response.end JSON.stringify result:html
      console.log "ok"
  crawl: ->
    crawlImage @params.url,(imageUrl)=>
      if imageUrl ==''
        @response.writeHead 200, {'Content-Type':'text/plain'}
        @response.end JSON.stringify error:true        
      else
        App.ImageHelper.write imageUrl,"item",(imageName)=>
          formJson.apply this,[imageName,'item']

