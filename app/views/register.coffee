div class:"page-title", -> "注册"
form id:"auth",class:"form-horizontal well",action:"/register",method:"POST", =>
  if typeof @errors != 'undefined' && @errors.length
    div class:"alert alert-error", id:"autherror", => @errors.join ''
  div class:"control-group", ->
    label class:"control-label",for:"name", "用户名"
    div class:"controls", ->
      input class:"input-xlarge validate[required,minSize[2]] ",type:"text",name:"name",id:"name"
  div class:"control-group", ->
    label class:"control-label",for:"email", "邮件"
    div class:"controls", ->
      input class:"input-xlarge validate[required,custom[email]]",type:"text",name:"email",id:"email"
  div class:"control-group", ->
    label class:"control-label",for:"password", "密码"
    div class:"controls", ->
      input class:"input-xlarge validate[required,minSize[4]]",type:"password",name:"password",id:"password"
  div class:"form-actions",->
    input type:"submit",class:"btn btn-primary",value:"注册"
    span class:"pull-right",->
      a href:"/login",->"已注册用户请直接登录"
coffeescript ->
  $ -> 
    $.validation "auth",['name','email','password']
    err = $ '#autherror'
    if err.length>0 then err.html $.authErr err.html()
