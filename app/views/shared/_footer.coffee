div class:"footer-links",->
  div class:"hr",->"&nbsp;"
  div ->
    a href:"/aboutus",->"关于"
    script "document.write(['<a hre'+'f=mailt'+'o:askguof'+'m@gm'+'ail'+'.com>联系我们</a>'].join(''))"
    a href:"http://weibo.com/u/2823730364",target:"_blank",->"关注微博"
  div class:"copyright",->
    a href:"http://www.miibeian.gov.cn/",target:"_blank",->"京ICP备12032993号"
cite class: "copyright",->
  if Tower.env is 'development' then span class:"label label-info",->"#{Tower.env} version"
  if Tower.env is 'staging' then span class:"label label-success",->"#{Tower.env} version"