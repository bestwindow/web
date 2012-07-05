domain = ""
imageSize = ""
path = ""

md5 = require "MD5"
moment = require 'moment'
magic = require 'imagemagick'
fs = require 'fs'
GridFS = require('GridFS').GridFS
gridfs=''

imageName =(type,file)->
  file.replace path,"#{moment().format('YYYY_MM_DD')}_#{domain}_#{type}_"


saveImage = (file,imagename_mongod,sizeArray,next)->
  magic.identify ['-format','%w.%h',file],(err,fileSize)->
    fWidth = fileSize.split('.')[0]
    fHeight = fileSize.split('.')[1]
    sizeArray.forEach (el,idx)->
      tempFile = "#{file}_#{idx}"
      wSize = if el == 0 || el > fWidth then fWidth else el
      hSize = parseInt fHeight*wSize/fWidth,10
      magic.resize {srcPath:file,dstPath:tempFile,quality:0.9,width:wSize,height:hSize},(err)->
        fs.readFile tempFile,(err,buffer)->
          gridfs.put buffer,("#{imagename_mongod}_#{idx}.jpg"),'w',(err,r)->
            fs.unlink (tempFile), ->
              fs.unlink(file,next) if idx == sizeArray.length-1
#app.set 'db-image-name', "#{app.domain}-img-development"
App.ImageHelper = ((option)->
    gridfs = new GridFS(option.db)
    domain = option.domain
    #console.log "App.imageSize:"+App.imageSize
    imageSize = option.imageSize
    path = option.path || '/tmp/'
    fn =
      writeLocal:(file,filename,next)->
        filename = "/tmp/#{md5 filename}"
        fs.writeFile filename,file,->next filename
      write:(file,type,next)->
        image = imageName(type,file)
        saveImage file,image,imageSize(type),->
          next image
      read:(file,next)->
        gridfs.get file,(err,filedata)->
          next filedata
    return fn
)(domain:Tower.domain.split('.')[0],imageSize:Tower.imageSize,db:"img-#{Tower.config.databases.mongodb[Tower.env].name}")






