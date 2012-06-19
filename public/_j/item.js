(function() {

  $(function() {
    var crawUrl, crawlChunk, crawlImage, initialize, showImage;
    crawlChunk = function(fn) {
      return $.get("/chunks.json", function(data) {
        var dom, el, html, _i, _len;
        dom = $("#chunkSelector");
        html = '';
        for (_i = 0, _len = data.length; _i < _len; _i++) {
          el = data[_i];
          html += "<span class=\"label chunks\" title=\"" + el.id + "\">" + el.title + "</span>";
        }
        dom.html("请选择发布到哪个类别:" + html);
        $('.chunks').click(function(e) {
          var d;
          if (top.chunkClick) top.chunkClick.removeClass("label-info");
          d = top.chunkClick = $(e.target);
          d.addClass("label-info");
          $("#chunktitle").val(d.html());
          return $("#chunkid").val(d.attr("title"));
        });
        return fn();
      });
    };
    crawlImage = function(imageUrl) {
      var url;
      url = '/image/crawl';
      $("#crawlImageBtn").attr('disabled', "disabled");
      $("#crawlImageBtn").attr('value', "正在抓取");
      return $.post(url, {
        url: imageUrl
      }, function(data) {
        data = JSON.parse(data);
        $("#crawlImageBtn").attr('disabled', false);
        $("#crawlImageBtn").attr('value', "使用这张图片");
        if (data.error) return alert("图片抓取失败");
        showImage(data[0]);
        $('#itemCrawler').addClass('hide');
        $('#itemEditor').removeClass('hide');
        if ($("#chunkid").val() === "" || $("#chunkid").val() === "undefined") {
          return crawlChunk(initialize);
        } else {
          return initialize();
        }
      });
    };
    crawUrl = function(e) {
      var dom, link, price, url;
      link = function(l) {
        var domain, id, idIndex, idPos, idStr, pureLink, targetDomain;
        targetDomain = function() {
          var el, _i, _len, _ref;
          _ref = ["taobao", "tmall"];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            el = _ref[_i];
            if (l.indexOf(el) > 0) return el;
          }
          return false;
        };
        idPos = function() {
          var el, _i, _len, _ref;
          _ref = ["?id=", "&id="];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            el = _ref[_i];
            if (l.indexOf(el) > 0) return el;
          }
          return false;
        };
        domain = targetDomain();
        if (domain === false) return alert("目前只直至抓取taobao.com, tmall.com下的商品信息");
        idIndex = idPos();
        if (idIndex === false) return alert("链接信息不完整,没有找到商品id");
        idStr = l.split(idIndex)[1];
        id = idStr.split("&")[0];
        pureLink = "http://detail.tmall.com/item.htm?id=" + id;
        return $('#linkhidden').val(pureLink);
      };
      price = function(p) {
        var pr;
        pr = parseFloat(p);
        if (!isNaN(pr)) {
          $("#price").val(pr);
          $("#money").val(pr);
          return true;
        } else {
          return false;
        }
      };
      url = '/image/crawlurl';
      dom = $("#targetUrlInput");
      if (dom.val() === '') return true;
      link(dom.val());
      $("#targetUrlBtn").attr('disabled', "disabled");
      $("#targetUrlBtn").attr('value', "正在抓取");
      return $.post(url, {
        url: dom.val()
      }, function(data) {
        var html, imageUrl, showSize, _i, _len, _ref;
        data = JSON.parse(data).result;
        $('#texthidden').val(unescape(data.title));
        if (price(data.price) === false) {
          return $("#crawlerResult").html("没有抓取到价格");
        }
        html = [];
        $("#targetUrlBtn").attr('disabled', false);
        $("#targetUrlBtn").attr('value', "确定");
        if (data.images.length <= 0) return $("#crawlerResult").html("没有抓取到图片");
        _ref = data.images;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          imageUrl = _ref[_i];
          html.push("<div class=item><img id=\"crawlerImage\" src=" + imageUrl + " onclick=crawlImage(this.src) />");
        }
        html = ["<div>共获得" + data.images.length + "张图片&nbsp;&nbsp;&nbsp;&nbsp;", "<input type=button onclick=\"$('#imageCarousel').carousel('prev')\" value=\"&lsaquo;\" />", "<input type=button onclick=\"$('#imageCarousel').carousel('next')\" value=\"&rsaquo;\" />&nbsp;&nbsp;&nbsp;&nbsp;", "<span id=crawlerInfo></span>", "<input type=button id=crawlImageBtn value=\"使用这张图片\" />", "</div>", '<div id="imageCarousel" class="carousel slide">', '<div class="carousel-inner">', html.join('</div>'), '</div>', '</div>'].join("");
        $("#crawlerResult").html(html);
        $($('#imageCarousel .item')[0]).addClass('active');
        $("#crawlImageBtn").click(function() {
          return crawlImage($('#imageCarousel .active img').attr("src"));
        });
        showSize = function() {
          var d;
          d = $('#imageCarousel .active img');
          return $('#crawlerInfo').html("图片长宽:" + (d.width()) + " X " + (d.height()));
        };
        setTimeout(showSize, 2500);
        dom = $('#imageCarousel');
        dom.carousel({
          interval: 6000000
        });
        return dom.on('slid', showSize);
      });
    };
    $("#targetUrlBtn").click(crawUrl);
    $("#targetUrlInput").keyup(function(event) {
      if (event.type === "keyup" && event.which === 13) return crawUrl();
    });
    showImage = function(file) {
      $("#pictureinput")[0].value = file.thumbnail_url.split("image/")[1].replace("_0.jpg", "");
      $("#fileupload").css("display", "none");
      $(".left").css("border", "8px solid #eee");
      $("<div>").html("<a href=" + file.url + " target=_blank><img src=" + file.url + " width=430 /></a>").appendTo($("#fileresult"));
      return $('#pictureclose').css("display", "block");
    };
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
            return showImage(file);
          });
        }
      });
      $.epicEditor = new EpicEditor(document.getElementById('text'));
      $.epicEditor.$filename = 'editor';
      $.epicEditor.remove($.epicEditor.$filename);
      $.epicEditor.options({
        file: {
          defaultContent: decodeURI($('#texthidden').val()),
          name: $.epicEditor.$filename
        },
        basePath: "/_libs/epiceditor",
        themes: {
          preview: '/themes/preview/github.css',
          editor: '/themes/editor/epic-light.css'
        }
      }).load();
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
      $("#item-form").submit(function(e) {
        var after, alertDom, alertr, before, chunkid, html, noerror, picture, price, text, validate;
        noerror = true;
        alertDom = $(".alert");
        text = $("#texthidden");
        html = $('#htmlhidden');
        price = $("#price");
        picture = $("#pictureinput");
        chunkid = $("#chunkid");
        alertr = function(text) {
          alertDom.html(text);
          return noerror = false;
        };
        before = function() {
          return text.val($.epicEditor.get('editor').value);
        };
        validate = function() {
          if (chunkid.val() === "" || chunkid.val() === "undefined") {
            return alertr("请选择发布到哪个类别");
          } else if (picture.val() === "") {
            return alertr("请上传一张货物图片");
          } else if (text.val() === "" || text.val() === "货物描述") {
            return alertr("请填写货物描述");
          } else if (price.val() === "" || parseInt(price.val()) === 0) {
            return alertr("请填写货物价格");
          }
        };
        after = function() {
          html.val($.epicEditor.exportHTML());
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
      if ($('#price').val() !== '') {
        $("#money").val($('#price').val());
        $.money();
        $("#money").mask();
      }
      if ($('#pictureinput').val() !== '') {
        return $('#pictureclose').css("display", "block");
      }
    };
    if ($('#itemCrawler').length === 0) return initialize();
  });

}).call(this);
