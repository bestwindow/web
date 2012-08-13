formidable = require 'formidable'
util = require 'util'
request = require 'request'
jsdom  = require 'jsdom'
fs     = require 'fs'
Iconv  = require('iconv').Iconv
jquery = fs.readFileSync("./public/_j/jquery.min.js").toString()


class App.ImagesController extends App.ApplicationController
  
  crawlHtml=(urls,fn)->
    url = "http://#{urls.split('http://')[1]}"
    domainList = ['taobao.com','tmall.com','amazon.com','amazon.cn']
    exchangeRate = 
      us:6.4
    domain = ((u)->
      for el in domainList
        if u.replace('://','').split('/')[0].indexOf(el)>=0 then return el
      false
    ) url
    res = images:[]
    options = (->
      o = url:url,timeout:30000
      if ["tmall.com","taobao.com"].indexOf(domain)>=0 then o.encoding = null
      o
    )()
    imagesByBookmark = (->
      imageArray = urls.split 'http://'
      if imageArray.length<2 then return []
      for i in [0..imageArray.length-1] 
        imageArray[i] = "http://#{imageArray[i]}"
      imageArray.splice 2
    )()
    afterRequest = (error, response, body)->
      process = 
        'amazon.com':(errors,window)->
          imageHost = "http://ecx.images-amazon.com/images/"
          if errors or !window or !window.$ then return fn []
          $ = window.$
          res.title = escape $('title').html()
          res.price = (->
            dom = $('.priceLarge')
            if !dom.html() then return 0
            priceHtml = dom.html()
            if priceHtml.indexOf('￥ ')>=0
              priceHtml = (parseFloat dom.html().replace('￥ ','')).toFixed 2
            else
              priceHtml = ((parseFloat dom.html().replace('$','')) * exchangeRate.us).toFixed 2
            ("#{priceHtml}").replace '.00',''
          )()
          res.images = (->
            imageArray = []
            for i in imagesByBookmark.concat($.makeArray $ 'img')
              if typeof(i) is 'string'
                imageArray.push i
              else
                el = $ i
                if el.attr('src').indexOf(".jpg")>0 then imageArray.push el.attr 'src'
            imageArray
          )()
          fn res            
            
        "taobao.com":(errors, window)->
          if errors or !window or !window.$ then return fn []
          $ = window.$
          res.title = escape $("title").html()
          res.price = $('#J_StrPrice').html()
        
          next = ->
            for i in [].concat($.makeArray $ "#header img")
            .concat($.makeArray $ '#J_UlThumb img')
            .concat($.makeArray $ ".J_TRegion img")
            .concat($.makeArray $ "#J_DivItemDesc img")
            .concat($.makeArray $ ".tb-shop img")
              el = $ i
              if el.attr('src').indexOf(".jpg")>0
                res.images.push "#{el.attr('src').split('.jpg')[0]}.jpg"
              else
                res.images.push el.attr('src').split('?')[0]
            fn res
        
          apiItemDesc = false
          scriptAddress = false
          for i in [].concat($.makeArray $ 'textarea').concat($.makeArray $ 'script')
            el = $ i
            scriptString = el.text()+el.val()
            if scriptString.indexOf('apiItemDesc":"')>=0
              apiItemDesc = true
              scriptAddress = scriptString.split('apiItemDesc":"')[1].split('"')[0].replace /\\/g,''
          if apiItemDesc && scriptAddress
            try
              request {url:scriptAddress},(sc_error, sc_response, sc_body)->
                if sc_body.indexOf("var desc='")>=0
                  $('#header').html sc_body.split("var desc='")[1].split("';")[0]
                next()
            catch error
              next()
          else
            next()
      process["tmall.com"] = process["taobao.com"]
      process["amazon.cn"] = process["amazon.com"]
      
      decoder = ->
        if domain is false then return fn images:[],title:'',price:''
        if ["tmall.com","taobao.com"].indexOf(domain)>=0
          gbk_to_utf8_iconv = new Iconv 'GBK', 'UTF-8'
          try
            body = gbk_to_utf8_iconv.convert body
          catch error
            body = String body
  
        jsdom.env
          html: body||""
          src: [jquery]
          done:process[domain]

      decoder()

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
      forceSize = false
      for el in fields
        if el[0] is 'type' then type = el[1]
        if el[0] is 'size' then forceSize = parseInt el[1],10
      file = files[0][1].path
      App.ImageHelper.write file,type,forceSize,(imageName)=>formJson.apply this,[imageName,'item']
    form.parse @request
  show:->
    App.ImageHelper.read "#{@request.params.id}.jpg",(fileData)=>
      @response.writeHead 200, {'Content-Type': 'image/jpeg' }
      @response.end fileData, 'binary'
  crawlUrl: ->
    crawlHtml @params.url,(html)=>
      @response.writeHead 200, {'Content-Type':'text/plain'}
      @response.end JSON.stringify result:html
  crawl: ->
    forceSize = @params.size || false
    crawlImage @params.url,(imageUrl)=>
      if imageUrl ==''
        @response.writeHead 200, {'Content-Type':'text/plain'}
        @response.end JSON.stringify error:true        
      else
        App.ImageHelper.write imageUrl,"item",forceSize,(imageName)=>
          formJson.apply this,[imageName,'item']

