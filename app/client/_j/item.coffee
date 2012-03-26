$ ->
  


  $.money = ->
    $("#money").maskMoney
      symbol: "￥ "
      showSymbol: true
      symbolStay: true
      precision: 0

  initialize = ->    
    $("#fileupload").fileupload
      dataType: "json"
      url: "/image"
      formData:type:"item"
      done: (e, data) ->
        $.each data.result, (index, file) ->
          $("#pictureinput")[0].value = file.thumbnail_url.split("image/")[1].replace("_0.jpg", "")
          $("#fileupload").css "display", "none"
          $(".left").css "border", "8px solid #eee"
          $("<div>").html("<a href=#{file.url} target=_blank><img src=#{file.url} width=430 /></a>").appendTo $("#fileresult")
          $('#pictureclose').css "display","block"


    $('#pictureclose').click (e)->
      e.target.style.display='none'
      $("#pictureinput")[0].value = ''
      $("#fileupload").css "display", "block"
      $(".left").css "border", "8px dashed #CCC"
      $("#fileresult").html ''


    $("#money").focus (e) ->
      if e.target.value is "￥"
        e.target.value = ""
        $.money()

    $("#money").keyup (e) ->
      unless e.target.value is "￥" or e.target.value is "" or e.target.value is "￥ "
        money = parseInt($.trim(e.target.value.replace(/￥/g, "").replace(/,/g, "").replace(/%/g, "")), 10)
        $("#price").val money  unless isNaN(money)

    $("#text").focus (e) ->
      $(e.target).val ""  if $(e.target).val() is "货物描述"

    $("#item-form").submit (e) ->
      noerror = true
      alertDom = $(".alert")
      alertr = (text)->
        alertDom.html text
        noerror = false
      if $("#pictureinput").val() is ""
        alertr "请上传一张货物图片"
      else if $("#price").val() is "" or parseInt($("#price").val()) is 0
        alertr "请填写货物价格"
      else if $("#text").val() is "" or $("#text").val() is "货物描述"
        alertr "请填写货物描述"
      if noerror is false
        alertDom.addClass "alert-error"
        alertDom.addClass "in"
      noerror


    if $('#price').val()!='' 
      $("#money").val $('#price').val()
      $.money()
      $("#money").mask()
    
    if $('#pictureinput').val()!=''
      $('#pictureclose').css "display","block"




  initialize()


