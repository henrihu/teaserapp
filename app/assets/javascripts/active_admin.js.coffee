#= require active_admin/base
#= require select2
$(document).ready ->
#  $('#video_name').keydown (e) ->
#    if  e.which == 13
#      e.preventDefault
#      $('#new_video').preventDefault
#
  $('#new_video').find('#video_name').keypress (e) ->
    if  e.which == 13
      $(this).next().focus();  #//Use whatever selector necessary to focus the 'next' input
  $('#select2-search').find('#s2id_autogen1_search').keypress (e) ->
    if  e.which == 13
      request = $.ajax ({
        url: "/admin/videos/imdb_title",
        method: "GET",
        data: { search : 'gone' },
        timeout: 50,
        dataType: "json",
#        beforeSend:    ->
#          $('#video_name').prop 'disabled', true
      })
#      .beforeSend ->
#        $('#video_name').prop 'disabled', true
#      .complete ->
#        $('#video_name').prop 'disabled', false
      .done (msg) ->
        console.log msg
#        add_scroll_div msg

      .fail ( jqXHR, textStatus ) ->
        add_scroll_div msg
        alert "Request failed: " + textStatus

      false

  add_scroll_div = (msg =[]) ->
    $('#main_content').append('<div class="sgt_div"><ul class ="sgt_ul"><li>asdf</li></ul></div>')

  $("#video_name").select2 width: "80%"
  $("#video_genre_ids").select2 width: "25%"
  $("#video_year").select2 width: "10%"
#  $('#star').raty { half: true }









#return

