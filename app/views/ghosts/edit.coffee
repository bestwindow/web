contentFor "title", "Editing Ghost"

javascriptTag '/_j/jquery.validationEngine-zh_CN.js'
javascriptTag '/_j/jquery.validationEngine.js'
javascriptTag '/_j/auth.js'

ul class:"breadcrumb",=>
  li ->
    a href:'/', '首页'
    span class:"divider",'/'  
  li class:"active", =>"帐户设置"

ghost = @ghost
div class:"form-horizontal well", ->
  formFor @ghost, (f) ->
    div class:"control-group", ->
      label class:"control-label",for:"ghost-email-input","邮件"
      div class:"controls", ->
        input class:"input-xlarge validate[required,custom[email]]",name:"ghost[email]",id:"ghost-email-input",value:ghost.email,type:"text"
    
    div class:"control-group", ->
      label class:"control-label",for:"ghost-name-input","用户名"
      div class:"controls", ->
        input class:"input-xlarge validate[required,minSize[2]]",name:"ghost[name]",id:"ghost-name-input",value:ghost.name,type:"text"
    
    div class:"control-group", ->
      label class:"control-label",for:"ghost-oldpass-input","旧密码"
      div class:"controls", ->
        input class:"input-xlarge",name:"ghost[oldpassword]",id:"ghost-oldpass-input",type:"password"
    
    div class:"control-group", ->
      label class:"control-label",for:"ghost-pass-input","新密码"
      div class:"controls", ->
        input class:"input-xlarge validate[minSize[4]]",name:"ghost[password]",id:"ghost-pass-input",type:"password"
    
    div class:"form-actions",->
      input type:"submit",class:"btn btn-primary",value:"保存"
      a href:"/ghosts",class:"btn","取消"

coffeescript ->
  $ -> 
    $.validation "ghost-form",['ghost-email-input','ghost-name-input','ghost-pass-input']



        
