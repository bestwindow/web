(function() {

  $(function() {
    var crawUrl, crawlChunk, crawlImage, initialize, showImage;
    crawlChunk = function(fn) {
      return $.get("/chunks.json", function(data) {
        var checked, chunker, chunkid, chunks, dom, e1, e2, e2Key, e2Value, e3, html, key, template, value, _i, _j, _len, _len2;
        dom = $("#chunkSelector");
        html = '';
        chunkid = $("#chunkid");
        chunks = chunkid.val() === "" ? [] : chunkid.val().split(",");
        chunker = function(path) {
          var el, _i, _len;
          for (_i = 0, _len = data.length; _i < _len; _i++) {
            el = data[_i];
            if (el.path === path.toLowerCase().trim()) return el;
          }
          return null;
        };
        checked = function(id) {
          if (chunks.indexOf(id) >= 0) {
            return "checked=checked";
          } else {
            return "";
          }
        };
        template = function(oc, lv, ends) {
          if (oc) {
            return "<div class=\"chunks" + lv + " " + (ends || '') + "\"><div><input value=\"" + oc.id + "\" type=checkbox class=chunks " + (checked(oc.id)) + " />" + oc.title + "</div>";
          } else {
            return "";
          }
        };
        for (key in chunkDef) {
          value = chunkDef[key];
          e1 = chunker(key);
          html += template(e1, 1);
          if (value.push) {
            for (_i = 0, _len = value.length; _i < _len; _i++) {
              e2 = value[_i];
              e2 = chunker(e2);
              html += "" + (template(e2, 2, 'ends2')) + "</div>";
            }
          } else {
            for (e2Key in value) {
              e2Value = value[e2Key];
              e2 = chunker(e2Key);
              html += template(e2, 2);
              for (_j = 0, _len2 = e2Value.length; _j < _len2; _j++) {
                e3 = e2Value[_j];
                e3 = chunker(e3);
                html += "" + (template(e3, 3)) + "</div>";
              }
              html += "</div>";
            }
          }
          html += '</div>';
        }
        dom.html("请选择发布到哪个类别:" + html);
        $('.chunks').bind('click', function(e) {
          var i, _ref, _ref2;
          dom = $(e.target);
          chunkid = $("#chunkid");
          chunks = chunkid.val() === "" ? [] : chunkid.val().split(",");
          if (dom.is(':checked')) {
            for (i = _ref = chunks.length - 1; _ref <= 0 ? i <= 0 : i >= 0; _ref <= 0 ? i++ : i--) {
              if (chunks[i] === dom.val()) return true;
            }
            if (dom.parents('.chunks3').length > 0) {
              e2 = $($(dom.parents('.chunks2')).find('input')[0]);
              e2.attr('checked', 'checked');
              if (chunks.indexOf(e2.val()) < 0) chunks.push(e2.val());
            }
            if (dom.parents('.chunks2').length > 0) {
              e1 = $($(dom.parents('.chunks1')).find('input')[0]);
              e1.attr('checked', 'checked');
              if (chunks.indexOf(e1.val()) < 0) chunks.push(e1.val());
            }
            if (chunks.indexOf(dom.val()) < 0) chunks.push(dom.val());
          } else {
            for (i = _ref2 = chunks.length - 1; _ref2 <= 0 ? i <= 0 : i >= 0; _ref2 <= 0 ? i++ : i--) {
              if (chunks[i] === dom.val()) chunks.splice(i, 1);
            }
          }
          return chunkid.val(chunks.join(","));
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
        $('.bookmark').addClass('hide');
        $('#itemEditor').removeClass('hide');
        return crawlChunk(initialize);
      });
    };
    top.targetUrlBtnReset = function(fn) {
      var d;
      d = $("#targetUrlBtn");
      d.removeAttr('disabled');
      d.attr('value', "确定");
      return fn();
    };
    top.targetUrlBtnDisable = function() {
      var d;
      d = $("#targetUrlBtn");
      d.attr('disabled', "disabled");
      return d.attr('value', "正在抓取");
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
        if (domain === false) {
          return targetUrlBtnReset(function() {
            return alert("目前只直至抓取taobao.com, tmall.com下的商品信息");
          });
        }
        idIndex = idPos();
        if (idIndex === false) {
          return targetUrlBtnReset(function() {
            return alert("链接信息不完整,没有找到商品id");
          });
        }
        idStr = l.split(idIndex)[1];
        id = idStr.split("&")[0];
        pureLink = "http://detail.tmall.com/item.htm?id=" + id;
        $('#linkhidden').val(pureLink);
        return true;
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
      if (dom.val() === '' || !link(dom.val())) return true;
      targetUrlBtnDisable();
      return $.post(url, {
        url: dom.val()
      }, function(data) {
        var render;
        data = JSON.parse(data).result;
        $('#texthidden').val(unescape(data.title));
        if (price(data.price) === false) {
          return targetUrlBtnReset(function() {
            return $("#crawlerResult").html("没有抓取到价格");
          });
        }
        $("#targetUrlBtn").attr('disabled', false);
        $("#targetUrlBtn").attr('value', "确定");
        if (data.images.length <= 0) {
          return targetUrlBtnReset(function() {
            return $("#crawlerResult").html("没有抓取到图片");
          });
        }
        render = function(sortBySize) {
          var el, html, htmlTemp, i, imageUrl, str, _i, _j, _len, _len2, _ref;
          html = [];
          for (i = 0, _ref = data.images.length - 1; 0 <= _ref ? i <= _ref : i >= _ref; 0 <= _ref ? i++ : i--) {
            imageUrl = data.images[i];
            if (imageUrl && imageUrl !== "" && imageUrl.indexOf("/") > 0) {
              html.push("<div class=\"item span3\"><div><img id=\"crawlerImage" + i + "\" src=\"" + imageUrl + "\" onclick=setCrawlImage(this) /></div><div><a href=\"" + imageUrl + "\" target=_blank><i class=icon-zoom-in></i><span class=title id=crawlerDiv" + i + "></span></a></div>");
            }
          }
          if (sortBySize) {
            htmlTemp = [];
            for (_i = 0, _len = sortBySize.length; _i < _len; _i++) {
              el = sortBySize[_i];
              for (_j = 0, _len2 = html.length; _j < _len2; _j++) {
                str = html[_j];
                if (str.indexOf(el.imageId) > 0) if (htmlTemp.push(str)) break;
              }
            }
            html = htmlTemp;
            $('#imageCarousel .row-fluid').html(html.join('</div>'));
          } else {
            html = ["<div>共获得" + data.images.length + "张图片&nbsp;&nbsp;&nbsp;&nbsp;", "<span id=crawlerInfo></span>", "<input type=button class=btn id=sizeImageBtn value=\"按大小排序\" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;", "<input type=button class=\"btn btn-primary\" id=crawlImageBtn value=\"抓取图片\" />", "</div>", '<div id="imageCarousel">', '<div class=row-fluid>', html.join('</div>'), '</div>', '</div>'].join("");
            $("#crawlerResult").html(html);
          }
          return $("#crawlerResult .item img").load(function() {
            var size, target;
            dom = $(this);
            target = $("#crawlerDiv" + (dom.attr('id').replace('crawlerImage', '')));
            size = {
              width: dom.width(),
              height: dom.height()
            };
            target.html(size.width + " X " + size.height);
            if (size.width > size.height) {
              return dom.css("width", "132px");
            } else {
              return dom.css("height", "152px");
            }
          });
        };
        render();
        top.setCrawlImage = function(dom) {
          dom = $(dom);
          if (top.CrawlImageParent) top.CrawlImageParent.css("background", 'gray');
          top.CrawlImageParent = $(dom.parents(".item"));
          top.CrawlImageParent.css("background", 'orange');
          return top.CrawlImage = dom.attr("src");
        };
        $('#sizeImageBtn').click(function() {
          var area, size, sizeTemp, sizes, _i, _len;
          sizes = $("#imageCarousel .item .title");
          area = [];
          for (_i = 0, _len = sizes.length; _i < _len; _i++) {
            size = sizes[_i];
            sizeTemp = $(size).html().split('X');
            area.push({
              imageId: "crawlerImage" + ($(size).attr('id').replace('crawlerDiv', '')),
              area: (sizeTemp.length < 2 ? 0 : parseInt(sizeTemp[0], 10) * parseInt(sizeTemp[1]))
            });
          }
          area.sort(function(a, b) {
            return b.area - a.area;
          });
          return render(area);
        });
        return $("#crawlImageBtn").click(function() {
          if (top.CrawlImage) return crawlImage(top.CrawlImage);
        });
      });
    };
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
    return (function() {
      var input, url;
      $("#targetUrlBtn").bind('click', crawUrl);
      $("#targetUrlInput").keyup(function(event) {
        if (event.type === "keyup" && event.which === 13) return crawUrl();
      });
      if ($('#itemCrawler').length === 0) crawlChunk(initialize);
      if ($('#website').length > 0) {
        input = $('#website');
        url = decodeURIComponent(input.val().replace(/\-/g, '.'));
        if (url === '') return true;
        if (url.indexOf('http://') < 0) url = 'http://' + url;
        $("#targetUrlInput").val(url);
        return $("#targetUrlBtn").trigger('click');
      }
    })();
  });

}).call(this);
