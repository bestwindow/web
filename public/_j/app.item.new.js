$(function () {


  $("#item-form").submit(function(e){
    var alertr = $(".alert")
    var noerror = true
    if($("#pictureinput").val()=='')
    {
      alertr.html('需要一张货物图片')
      noerror = false
    }
    else if($("#price").val()=='' || parseInt($("#price").val())===0)
    {
      alertr.html('需要货物价格')
      noerror = false
    }
    else if($("#text").val()=='' || $("#text").val()=='货物描述')
    {
      alertr.html('需要货物描述')     
      noerror = false
    }
    if(noerror==false)alertr.addClass('in')
    return noerror
  })

    
});
