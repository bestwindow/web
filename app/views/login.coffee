div class:"page-title", -> "登录"
form id:'auth',class:"form-horizontal well",action:"login",method:"POST", ->
  if typeof @errors != 'undefined' && @errors.length
    div class:"alert alert-error", id:"autherror", => @errors.join ''
  div class:"control-group", ->
    label class:"control-label",for:"email", "邮件"
    div class:"controls", ->
      input class:"input-xlarge validate[required,custom[email]]",type:"text",name:"email",id:"email"
  div class:"control-group", ->
    label class:"control-label",for:"password", "密码"
    div class:"controls", ->
      input class:"input-xlarge validate[required,minSize[4]]",type:"password",name:"password",id:"password"
  div class:"form-actions",->
    input type:"submit",class:"btn btn-primary",value:"登录"
    span class:"pull-right",->
      a href:"/register",->"未注册用户请注册"
coffeescript ->
  $ -> 
    $.validation "auth",['email','password']
    err = $ '#autherror'
    if err.length>0 then err.html $.authErr err.html()
