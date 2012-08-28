App.GhostHelper =
  findGhost:(query,next)->
    query = if query.indexOf('@')>0 then {email:query} else {user:query}
    App.Ghost.where(query).first next
  isSelf:(objectId)->
    if !@request.user then return false
    return String(objectId)== String @request.user.get 'id'
  responsibility:->
    rbty = false
    if !@request.user then return 'anonymous'
    switch @request.user.responsibility
      when 1 then     rbty = 'engineer'
      when 10 then    rbty = 'webmaster'
      when 100 then   rbty = 'director'
      when 1000 then  rbty = 'editor'
      when 10000 then rbty = 'user'
      else rbty = 'anonymous'
    rbty
  ghostElements: ->
    $(".ghosts")
