function fade_address(address){
  address.bind('click', function(){
    address.animate({ 'color': 'white' }, 'fast', function(){
      $(this).attr('value', '');
      address.css('color', '#333333')
    });
    $(this).unbind('click');
  });
}

jQuery(document).ready(function($){
  fade_address($("#f_address"));
  jQuery("#equalize").equalHeights();
  $(".basic_info").tabs();
});

jQuery(document).ajaxSend(function(event, request, settings) {
  if(typeof(AUTH_TOKEN) == "undefined") return;
  if(settings.type == "GET") return;
  if(settings.contentType != "application/x-www-form-urlencoded") return;
  if(settings.data)
    settings.data += "&";
  else {
    request.setRequestHeader("Content-Type",settings.contentType);
    settings.data = "";
  }
  settings.data += "authenticity_token=" + encodeURIComponent(AUTH_TOKEN);
});
