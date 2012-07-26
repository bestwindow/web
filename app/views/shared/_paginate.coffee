text "     "
if @paginate.end
  div class:"row",->
    div class:"span12",-> 
      div class:"alert alert-block",->
        text "当前页没有内容"
        if @paginate.page!=1 then text ",请返回上一页"
nextPageNumber = @paginate.page+1
div class:"pagination pagination-centered",=>
  ul =>
    if @paginate.page is 1 then li class:"disabled",->a "< 前页"
    else li => linkTo "< 前页","#{@paginate.route}#{@paginate.page-1}"
    li => a @paginate.page
    if @paginate.end then li class:"disabled",->a "后页 >"
    else li =>linkTo "后页 >","#{@paginate.route}#{@paginate.page+1}"