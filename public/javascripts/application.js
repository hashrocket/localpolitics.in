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

  jQuery("#search_zip").submit(function($) {
    zip_code = jQuery("#f_address").val();
    if ( zip_code.match(/^\d+$/) ) {
      if (zip_code.length != 5) {
        jQuery("#zip_code_error").show();
        jQuery("#flash_errors").hide();
        return false;
      }
    }
  });
  jQuery("#send_twitter_invite").livequery('submit', function($) {
    if ( (jQuery("#subject").val() == '') || (jQuery("#citizen_email").val() == '') ){
      alert("Please fill in subject and email before sending.");
      return false;
    } else {
      var destination_url = jQuery("#twitter_invite_url").val();
      var form_params = jQuery("#send_twitter_invite").serializeArray()
      jQuery.post(destination_url, form_params, function(data) {
        jQuery(".invite_to_twitter").hide();
        jQuery(".invited_to_twitter").fadeIn('slow');
        jQuery(document).trigger('close.facebox')
        set_twitter_cookie(jQuery("#congress_person_crp_id").val());
      });
      return false;
    }
  });

  // facebox breaks the culerity test suite, so we've placed this call last
  jQuery('a[rel*=facebox]').facebox();

  $(".basic_info").tabs();
});

function set_twitter_cookie(id) {
  var expire_date = new Date("December 21, 2012");
  expire_date.setTime(expire_date.getTime());
  previous_values = jQuery.cookie('twitter_invites');
  if (!(previous_values && previous_values.indexOf(id) >= 0)) {
    new_values = id;
    if ( previous_values ) {
      new_values += ',' + previous_values;
    }
    jQuery.cookie('twitter_invites', new_values, { path: '/', expires: expire_date });
  }
}

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
