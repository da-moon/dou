Services = {
    ws : function (options){
        $.ajax(options);
    },
    post : function (options){
        $.post(options);
    }
}

// var csrftoken = Cookies.get('csrftoken');
var csrftoken = $.cookie('csrftoken');
function csrfSafeMethod(method) {
  // these HTTP methods do not require CSRF protection
  return (/^(GET|HEAD|OPTIONS|TRACE)$/.test(method));
}

jQuery.ajaxSetup({
  beforeSend: function(xhr, settings) {
    if (!csrfSafeMethod(settings.type) && !this.crossDomain) {
      xhr.setRequestHeader("X-CSRFToken", csrftoken);
    }
  }
});
