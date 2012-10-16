$ ->

  initialize = ->    
    $("#fileupload").fileupload
      dataType: "json"
      url: "/image"
      formData:type:"item"
      done: (e, data) ->
        $.each data.result, (index, file) ->
          $("#pictureinput")[0].value = file.thumbnail_url.split("image/")[1].replace("_0.jpg", "")
          $("#fileupload").css "display", "none"
          $(".left").css "border", "30px solid #eee"
          $("<div>").html("<a href=#{file.url} target=_blank><img src=#{file.url} /></a>").appendTo $("#fileresult")
          $('#pictureclose').css "display","block"


    $.epicEditor = new EpicEditor
      container:'text'
      file:defaultContent:decodeURI($('#texthidden').val()),name:'editor'
      basePath:"/_libs/epiceditor"
      themes:
        base:'/themes/base/epiceditor.css'
        preview:'/themes/preview/github.css'
        editor:'/themes/editor/epic-light.css'
    $.epicEditor.remove 'editor'
    $.epicEditor.load ->

    $('#pictureclose').click (e)->
      e.target.style.display='none'
      $("#pictureinput")[0].value = ''
      $("#fileupload").css "display", "block"
      $(".left").css "border", "8px dashed #CCC"
      $("#fileresult").html ''


    $("#item-form").submit (e) ->
      noerror   = true
      alertDom  = $ ".alert"
      text      = $ "#texthidden"
      html      = $ '#htmlhidden'
      title     = $ "#titleinput"
      picture   = $ "#pictureinput"
      alertr    = (text)->
        alertDom.html text
        noerror = false
      before    = ->
        text.val $.epicEditor.getElement('editor').body.innerText
      validate  = ->
        if picture.val() is ""
          alertr "请上传一张货物图片"
        else if text.val() is "" or text.val() is "货物描述"
          alertr "请填写货物描述"
        else if title.val() is ""
          alertr "请填写标题"
      after     = ->
        $.epicEditor.preview()
        html.val $.epicEditor.getElement('previewer').getElementById('epiceditor-preview').innerHTML
        if noerror is false
          alertDom.addClass "alert-error"
          alertDom.addClass "in"
      before()
      validate()
      after()
      noerror


    if $('#pictureinput').val()!=''
      $('#pictureclose').css "display","block"




  initialize()


