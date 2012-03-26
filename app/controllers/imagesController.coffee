formidable = require 'formidable'
util = require 'util'

class App.ImagesController extends App.ApplicationController
  

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
      App.ImageHelper.write file,type,(imageName)=>
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
    form.parse @request
  show:->
    App.ImageHelper.read "#{@request.params.id}.jpg",(fileData)=>
      @response.writeHead 200, {'Content-Type': 'image/jpeg' }
      @response.end fileData, 'binary'

