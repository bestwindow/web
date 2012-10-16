div class:"footer-links",->
  div class:"hr",->"&nbsp;"
  div class:"copyright",->
    "( ´ ▽ ` )ﾉ(￣▽￣) @2012"
cite class: "copyright",->
  if Tower.env is 'development' then span class:"label label-info",->"#{Tower.env} version"
  if Tower.env is 'staging' then span class:"label label-success",->"#{Tower.env} version"