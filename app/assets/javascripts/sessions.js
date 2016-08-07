function sessions_observers() {
  $("#login_with_twitter").change(function(e){
  	var url = $("#twitter-login").attr("href");
    window.location.replace(url);
  });
}