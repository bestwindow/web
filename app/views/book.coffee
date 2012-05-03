link rel:"stylesheet",href:"/_j/deck/deck.core.css"
link rel:"stylesheet",href:"/_j/deck/extensions/scale/deck.scale.css"
link rel:"stylesheet",href:"/_j/deck/extensions/status/deck.status.css"
link rel:"stylesheet",href:"/_j/deck/theme/transition/horizontal-slide.css"
javascriptTag "/_j/modernizr.custom.js"
javascriptTag "/_j/deck/deck.core.js"
javascriptTag "/_j/deck/extensions/scale/deck.scale.js"
javascriptTag "/_j/deck/extensions/status/deck.status.js"


style '''
  body{background:#f7f7f7;padding:0px}
  #navigation,#footer{display:none}
  .container {width:1024px}
  .modal {display:none}
  .modal-footer .btn{display:none}
  .modal-footer {text-align:left}
  .modal-body {max-height:400px}
  .modal-body .img {width:360px;height:360px;overflow:hidden;float:left}
  .modal-body .img img {max-height:360px;max-width:360px;display:block;margin:auto}
  .modal-body .content{width:160px;padding-left:10px;padding-top:100px;float:left;overflow:hidden}  
  .modal-body .content .price{font-size:24px}
  .modal-body .content .text {font-size:0;margin-top:20px}

  .deck-container{padding:0px}
  .deck-container .deck-status{right:20px;bottom:0px}
  .slide h1{font-size:24px;text-align:left;font-weight:normal;padding:0px}


  #impress{width:1024px;height:635px;overflow:hidden}
  div.title {line-height:40px;font-size:24px}
  .five span {float:left;display:block;overflow:hidden;border:3px solid #f7f7f7}
  .five .block0 {width:345px;height:234px}
  .five .block1 {width:316px;height:234px}
  .five .block2 {width:345px;height:234px}
  .five .block3 {width:506px;height:356px}
  .five .block4 {width:506px;height:356px}
  .five img {width:100%}
  .five .text {display:none}


  .five1 span {float:left;display:block;overflow:hidden;border:3px solid #f7f7f7}
  .five1 .block4 {width:345px;height:234px}
  .five1 .block3 {width:316px;height:234px}
  .five1 .block2 {width:345px;height:234px}
  .five1 .block1 {width:506px;height:356px}
  .five1 .block0 {width:506px;height:356px}
  .five1 img {width:100%}
  .five1 .text {display:none}


  .five2 span {float:left;display:block;overflow:hidden;border:3px solid #f7f7f7}
  .five2 .block0 {width:250px;height:200px}
  .five2 .block1 {width:250px;height:200px}
  .five2 .block2 {width:506px;height:356px}
  .five2 .block3 {width:506px;height:512px;margin-top:-156px}
  .five2 .block4 {width:506px;height:356px}
  .five2 img {width:100%}
  .five2 .text {display:none}

  .three span {display:block;overflow:hidden;padding:10px}
  .three img {width:100%}
  .three .block0{width:491px;height:615px;float:left;border-right:1px solid #ddd}
  .three .block0 .img {height:615px;overflow:hidden}
  .three .block0 .text {margin-top:-40px;color:white;font-size:18px;margin-left:10px}
  .three .block1{width:492px;height:294px;float:right;border-bottom:1px solid #ddd}
  .three .block1 .img {float:right;width:50%;height:294px;overflow:hidden}
  .three .block1 .text {float:left;width:50%;overflow:hidden}
  .three .block2{width:492px;height:290px;float:right}
  .three .block2 .img {height:290px;overflow:hidden}
  .three .block2 .text {margin-top:-40px;color:white;font-size:18px;margin-left:10px}
  .three .btn {display:none}

'''

div class:"modal",id:"itemModal", ->
  div class:"modal-body"
  div class:"modal-footer"

div ->
  script ->
    ('var bookItems='+JSON.stringify @items)

javascriptTag "/_j/book.js"
