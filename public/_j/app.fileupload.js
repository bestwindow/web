$(function () {
    $('#fileupload').fileupload({
        dataType: 'json',
        url: '/image',
        formData:{type:'item'},
        done: function (e, data) {
            $.each(data.result, function (index, file) {
                $('#pictureinput')[0].value = file.thumbnail_url.split('image/')[1].replace('_0.jpg','')
                $('<div>').html("<img src="+file.thumbnail_url+" />").appendTo($('#fileresult'));
            });
        }
    });
});