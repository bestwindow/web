App.ApplicationHelper = 
  beforeAction:(next)->
    if @session.flash
      @request.flashMessage = @session.flash
      delete @session.flash
    next()
