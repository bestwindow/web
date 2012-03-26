(function() {

  $(function() {
    var initialize;
    $.money = function() {
      return $("#money").maskMoney({
        symbol: "￥ ",
        showSymbol: true,
        symbolStay: true,
        precision: 0
      });
    };
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
            $(".left").css("border", "8px solid #eee");
            $("<div>").html("<a href=" + file.url + " target=_blank><img src=" + file.url + " width=430 /></a>").appendTo($("#fileresult"));
            return $('#pictureclose').css("display", "block");
          });
        }
      });
      $('#pictureclose').click(function(e) {
        e.target.style.display = 'none';
        $("#pictureinput")[0].value = '';
        $("#fileupload").css("display", "block");
        $(".left").css("border", "8px dashed #CCC");
        return $("#fileresult").html('');
      });
      $("#money").focus(function(e) {
        if (e.target.value === "￥") {
          e.target.value = "";
          return $.money();
        }
      });
      $("#money").keyup(function(e) {
        var money;
        if (!(e.target.value === "￥" || e.target.value === "" || e.target.value === "￥ ")) {
          money = parseInt($.trim(e.target.value.replace(/￥/g, "").replace(/,/g, "").replace(/%/g, "")), 10);
          if (!isNaN(money)) return $("#price").val(money);
        }
      });
      $("#text").focus(function(e) {
        if ($(e.target).val() === "货物描述") return $(e.target).val("");
      });
      $("#item-form").submit(function(e) {
        var alertDom, alertr, noerror;
        noerror = true;
        alertDom = $(".alert");
        alertr = function(text) {
          alertDom.html(text);
          return noerror = false;
        };
        if ($("#pictureinput").val() === "") {
          alertr("请上传一张货物图片");
        } else if ($("#price").val() === "" || parseInt($("#price").val()) === 0) {
          alertr("请填写货物价格");
        } else if ($("#text").val() === "" || $("#text").val() === "货物描述") {
          alertr("请填写货物描述");
        }
        if (noerror === false) {
          alertDom.addClass("alert-error");
          alertDom.addClass("in");
        }
        return noerror;
      });
      if ($('#price').val() !== '') {
        $("#money").val($('#price').val());
        $.money();
        $("#money").mask();
      }
      if ($('#pictureinput').val() !== '') {
        return $('#pictureclose').css("display", "block");
      }
    };
    return initialize();
  });

}).call(this);
