$(function(){
  /* If javascript is enabled this hides all sections by default */
  $(".accordianContent").css('display', 'none');
  /* Only show language selector if javascript is enabled */
  $('.lang').css('display', 'block');
});

/* Uses result of jquery.client to open the relevant section */
function OScheck() {
  var clientos = $.client.os;
  if(clientos == "Linux"){
    $('#linux').addClass('open');
  }else if(clientos == "Windows"){
    $('#windows').addClass('open');
  }else if(clientos == "Mac"){
    $('#apple').addClass('open');
  }else if(clientos == "iPhone/iPod"){
    $('#smartphone').addClass('open');
  }
}
  $(function(){
  OScheck();
});

/* Reset language default - needed in the event of returning to the page via back button */
function resetAll() {
  var f = document.forms;
  var last = f.length - 1;
  for (var i = 0; i < last; i++) {
    f[i].reset();
  }
}
