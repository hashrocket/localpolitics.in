jQuery(document).ready(function($){
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
