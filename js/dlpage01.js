$(function(){
  /* If javascript is enabled this hides all sections by default */
  $(".easy").css('display', 'none');
  /* Only show language selector if javascript is enabled */
  $('.lang').css('display', 'block');
  $('.lang-alt').css('display', 'none');
  $('.expander').css('display', 'block');
  $('.sidenav').css('display', 'none');
});

/* Uses result of jquery.client to open the relevant section */
function OScheck() {
  var clientos = $.client.os;
  if(clientos == "Linux"){
    $('.easy.linux').css('display', 'block');
  }else if(clientos == "Windows"){
    $('.easy.windows').css('display', 'block');
  }else if(clientos == "Mac"){
    $('.easy.mac').css('display', 'block');
  }else{
    $('.easy').css('display', 'block');
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

