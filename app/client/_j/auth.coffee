$ ->
  $.submitLock = ((init)->
    lock=init
    status:->lock
    on:(b)->
      lock=true
      b
    off:(b)->
      lock=false
      b
    toggle:(b)->
      lock = if lock==true then false else true
      b
  ) false

  $.validation = (formId,inputIds)->
    form = $ "##{formId}"
    form.submit (e)->
      if $.submitLock.status() then return false
      form = $ "##{formId}"
      $.submitLock.on()
      validate = (id)->
        dom = $ "##{id}"
        $('.formError').remove()
        if dom.attr('type')!='password' then dom.val $.trim dom.val()
        if dom.val()=='' && dom.attr('class').indexOf('required')>0 then true
        else form.validationEngine 'validateField', "##{id}"
      for input in inputIds
        if validate input then return $.submitLock.off false
      setTimeout (->submitLock.on true),10000
      true
  $.authErr = (e)->
    if e.indexOf("does not exist") > 0
      email = e.replace('User with login ','').replace " does not exist",''
      e = "does not exist"
    translate = 
      "Someone already has claimed that login.":"用户名或邮件已经注册过了"
      "Failed login.":"邮件或密码不正确"
      "Missing login.":"邮件或密码不正确"
      "Missing password.":"邮件或密码不正确"
      "does not exist":"\"#{email}\"这个邮件没有注册过"
    translate[e]

