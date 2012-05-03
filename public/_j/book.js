(function() {

  $(function() {
    var book, makeBook, pageIndex;
    $('body').prepend('<div id="impress" class="deck-container"></div>');
    book = $("#impress");
    pageIndex = [];
    top.page = [];
    top.findChunk = function(chunk) {
      var i, _ref;
      for (i = 0, _ref = page.length - 1; 0 <= _ref ? i <= _ref : i >= _ref; 0 <= _ref ? i++ : i--) {
        if (page[i] && page[i].chunk === chunk) return i;
      }
      return -1;
    };
    top.findItem = function(itemId) {
      var i, _ref;
      for (i = 0, _ref = bookItems.length - 1; 0 <= _ref ? i <= _ref : i >= _ref; 0 <= _ref ? i++ : i--) {
        if (bookItems[i].id.toString() === itemId.toString()) return bookItems[i];
      }
      return null;
    };
    top.showItem = function(itemId) {
      var html, item;
      item = findItem(itemId);
      if (item === null) return true;
      html = ["<div class=img><img src=/image/" + item.picture + "_7.jpg /></div>", "<div class=content><div class=\"price\">￥" + item.price + ".00</div>", "<div class=\"text\">" + item.text + "</div></div>"].join('');
      $('#itemModal .modal-body').html(html);
      $('#itemModal .modal-footer').html(item.text);
      return $('#itemModal').modal();
    };
    makeBook = function() {
      var blockLength, div, html, i, j, pagePos, pageType, pageTypeClass, _ref, _ref2, _ref3;
      html = '';
      pageTypeClass = {
        zero: [''],
        three: ['three'],
        five: ['five', 'five1', 'five2']
      };
      for (i = 0, _ref = bookItems.length - 1; 0 <= _ref ? i <= _ref : i >= _ref; 0 <= _ref ? i++ : i--) {
        pagePos = findChunk(bookItems[i].chunk);
        if (pagePos < 0) {
          pagePos = page.push({
            chunk: bookItems[i].chunk,
            chunkTitle: bookItems[i].chunktitle
          }) - 1;
        }
        if (!page[pagePos].items) page[pagePos].items = [];
        page[pagePos].items.push(bookItems[i]);
      }
      for (i = 0, _ref2 = page.length - 1; 0 <= _ref2 ? i <= _ref2 : i >= _ref2; 0 <= _ref2 ? i++ : i--) {
        div = "<div class=title>" + page[i].chunkTitle + "</div>";
        page[i].items.reverse();
        if (page[i].items.length >= 5) {
          blockLength = 5;
        } else if (page[i].items.length >= 3) {
          blockLength = 3;
        } else {
          blockLength = page[i].items.length;
        }
        for (j = 0, _ref3 = blockLength - 1; 0 <= _ref3 ? j <= _ref3 : j >= _ref3; 0 <= _ref3 ? j++ : j--) {
          div += "<span class=\"block" + j + "\" onclick=\"showItem('" + page[i].items[j].id + "')\"><div class=img><img src=/image/" + page[i].items[j].picture + "_7.jpg /></div><div class=text>" + page[i].items[j].text + "</div></span>";
        }
        if (page[i].items.length >= 5) {
          pageType = 'five';
        } else if (page[i].items.length >= 3) {
          pageType = 'three';
        } else {
          pageType = 'zero';
        }
        pageType = pageTypeClass[pageType][parseInt(Math.random() * pageTypeClass[pageType].length)];
        html += "<section class=\"bookpage slide " + pageType + "\">" + div + "</section>";
        html += '<p class="deck-status"><span class="deck-status-current"></span>/<span class="deck-status-total"></span></p>';
      }
      book.html(html);
      return $.deck('.slide');
    };
    return makeBook();
  });

}).call(this);
