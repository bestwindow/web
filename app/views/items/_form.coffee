edit = if @item.picture then true else false
formFor @item, (f) =>
  div class:"alert fade","&nbsp;"
  div id:"newitem", =>
    input name:"item[chunk]",type:"hidden",value:String @chunk.id
    input name:"item[chunktitle]",type:"hidden",value:String @chunk.title
    input name:"item[text]",type:"hidden",id:"texthidden",value:"#{if edit then encodeURI(@item.text) else '货物描述'}"
    input name:"item[html]",type:"hidden",id:"htmlhidden"
    input name:"item[picture]",type:"hidden",id:"pictureinput",value:"#{if edit then @item.picture else ''}"
    input name:"item[price]",type:"hidden",id:"price",value:"#{if @item.price then @item.price else ''}"
    div class:"content", =>
      a class:"pictureclose",id:"pictureclose",href:"#",=>'&nbsp;'      
      div class:"left", style:"#{if edit then 'border:30px solid #eee' else ''}", =>
        if !edit
          input id:"fileupload",type:"file",name:"files[]"
          div id:"fileresult"
        else
          input id:"fileupload",type:"file",name:"files[]",style:"display:none"
          div id:"fileresult",=>
            div =>
              a href:"/image/#{@item.picture}_7.jpg",target:"_blank",=>
                img src:"/image/#{@item.picture}_7.jpg",width:430
      div class:"right", =>
        div id:"text"
        input class:"money",id:"money",type:"text",value:"#{if @item.price then @item.price else '￥'}"
    div class:"footer", ->
      div class:"right", ->
        input class:"btn btn-primary",value:"#{if edit then '保存' else '发布'}",type:"submit"
        if edit then a class:"btn",href:"javascript:history.back()",->'取消'

contentFor "bottom", ->            
  javascriptTag '/_j/jquery.validationEngine-zh_CN.js'
  javascriptTag '/_j/jquery.validationEngine.js'
  javascriptTag "/_j/jquery.maskMoney.js"
  javascriptTag "/_j/jquery.ui.widget.js"
  javascriptTag "/_j/jquery.iframe-transport.js"
  javascriptTag "/_j/jquery.fileupload.js"
  javascriptTag '/_libs/epiceditor/epiceditor.js'
  javascriptTag "/_j/item.js"