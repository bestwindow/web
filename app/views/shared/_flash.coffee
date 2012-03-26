if typeof @request.flashMessage !='undefined'
  flash = @request.flashMessage
  for type in ['info','error','success','block']
    if typeof flash[type] !='undefined'
      div class:"alert alert-#{type}", id:"flashmessage", => flash[type].join '<br />'