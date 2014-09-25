#= require active_admin/base
#= require select2
$(document).ready ->
 $("#video_genre_ids").select2 width: "25%"
 $("#video_year").select2 width: "10%"
 $('#star').raty({ half: true });
return

