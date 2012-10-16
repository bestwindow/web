
$(function() {
  var initialize;
  initialize = function() {
    $("#fileupload").fileupload({
      dataType: "json",
      url: "/image",
      formData: {
        type: "item"
      },
      done: function(e, data) {
        return $.each(data.result, function(index, file) {
          $("#pictureinput")[0].value = file.thumbnail_url.split("image/")[1].replace("_0.jpg", "");
          $("#fileupload").css("display", "none");
          $(".left").css("border", "30px solid #eee");
          $("<div>").html("<a href=" + file.url + " target=_blank><img src=" + file.url + " /></a>").appendTo($("#fileresult"));
          return $('#pictureclose').css("display", "block");
        });
      }
    });
    $.epicEditor = new EpicEditor({
      container: 'text',
      file: {
        defaultContent: decodeURI($('#texthidden').val()),
        name: 'editor'
      },
      basePath: "/_libs/epiceditor",
      themes: {
        base: '/themes/base/epiceditor.css',
        preview: '/themes/preview/github.css',
        editor: '/themes/editor/epic-light.css'
      }
    });
    $.epicEditor.remove('editor');
    $.epicEditor.load(function() {});
    $('#pictureclose').click(function(e) {
      e.target.style.display = 'none';
      $("#pictureinput")[0].value = '';
      $("#fileupload").css("display", "block");
      $(".left").css("border", "8px dashed #CCC");
      return $("#fileresult").html('');
    });
    $("#item-form").submit(function(e) {
      var after, alertDom, alertr, before, html, noerror, picture, text, title, validate;
      noerror = true;
      alertDom = $(".alert");
      text = $("#texthidden");
      html = $('#htmlhidden');
      title = $("#titleinput");
      picture = $("#pictureinput");
      alertr = function(text) {
        alertDom.html(text);
        return noerror = false;
      };
      before = function() {
        return text.val($.epicEditor.getElement('editor').body.innerText);
      };
      validate = function() {
        if (picture.val() === "") {
          return alertr("请上传一张货物图片");
        } else if (text.val() === "" || text.val() === "货物描述") {
          return alertr("请填写货物描述");
        } else if (title.val() === "") {
          return alertr("请填写标题");
        }
      };
      after = function() {
        $.epicEditor.preview();
        html.val($.epicEditor.getElement('previewer').getElementById('epiceditor-preview').innerHTML);
        if (noerror === false) {
          alertDom.addClass("alert-error");
          return alertDom.addClass("in");
        }
      };
      before();
      validate();
      after();
      return noerror;
    });
    if ($('#pictureinput').val() !== '') {
      return $('#pictureclose').css("display", "block");
    }
  };
  return initialize();
});
