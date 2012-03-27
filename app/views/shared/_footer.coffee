cite class: "copyright",->
  if Tower.env is 'development' then span class:"label label-info",->"#{Tower.env} version"
  if Tower.env is 'test' then span class:"label label-success",->"#{Tower.env} version"