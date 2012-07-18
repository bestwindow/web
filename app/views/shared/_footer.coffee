div class:"footer-links",->
  div class:"hr",->"&nbsp;"
  div ->
    a href:"#",->"关于"
    a href:"#",->"联系我们"
    a href:"#",->"关注微薄"
  div class:"copyright",->
    "copyright..."
cite class: "copyright",->
  if Tower.env is 'development' then span class:"label label-info",->"#{Tower.env} version"
  if Tower.env is 'staging' then span class:"label label-success",->"#{Tower.env} version"