#= require active_admin/base
#= require select2


$(document).ready ->
#  $("#video_name").select2 width: "80%"
  $("#video_genre_ids").select2 width: "25%"
  $("#video_year").select2 width: "10%"
  #  $('#star').raty { half: true }
  $('#main_content').append('<div class="sgt_div select2-drop select2-drop-multi select2-display-none \ ' +
        'select2-drop-active" id="sgt_div_id"><ul id ="sgt_menu" class ="sgt_ul select2-results"></ul></div>')
  $('#sgt_div_id').hide()

  $('#new_video').find('#video_name').keypress (e) ->
    if  e.which == 13
      $(this).next().focus();  #//Use whatever selector necessary to focus the 'next' input
      search_val = $('#video_name').val()
      request = $.ajax ({
        url: "/admin/videos/imdb_title",
        method: "GET",
        data: { search : search_val },
        timeout: 50000,
        dataType: "json",
        beforeSend:    ->
          $('#video_name').prop 'disabled', true
      })
      .complete ->
        $('#video_name').prop 'disabled', false
        $('#sgt_div_id').show( "slow" )
      .done (msg) ->
        add_scroll_div msg
#      .fail ( jqXHR, textStatus ) ->
#        add_scroll_div "[]"
#        alert "Request failed: " + textStatus

      false

add_scroll_div = (msg =[]) ->
  $video_name = $('#video_name')
  input_position = $video_name.position()
  input_height = $video_name.height()
  input_width = $video_name.width()
  $sgt = $("#sgt_div_id")
  $sgt.css('left', input_position.left)
  $sgt.css('top', 18 + input_position.top + input_height )
  $sgt.css('width', input_width)
  $('#sgt_menu').empty()
  $.each(msg.id_title, (i, item) ->
    $a_id_title = $("<a>" + msg.id_title[i][1] + "</a>")
    $a_id_title.data("imdb_id", msg.id_title[i][0])
    $list_id_title = $('<li class="select2-results-dept-0 select2-result select2-result-selectable"></li>').append($a_id_title)
    $('#sgt_menu').append($list_id_title)
  )

  $('#sgt_menu li a').click ->
    $('#video_name').val($(this).text())
    id_val = $(this).data("imdb_id")
    $.ajax ({
      url: "/admin/videos/imdb_title",
      method: "GET",
      data: { id : id_val },
      timeout: 50000,
      dataType: "json",
      beforeSend:   ->
        $('#video_name').prop 'disabled', true
        $('#sgt_div_id').hide( "slow" )
    })
    .complete ->
      $('#video_name').prop 'disabled', false
    .done (msg) ->
      add_value_component msg
#      .fail ( jqXHR, textStatus ) ->
#        add_scroll_div "[]"
#        alert "Request failed: " + textStatus

add_value_component = (msg = []) ->
  add_value_genres msg.genres
  add_value_year msg.year
  add_value_director msg.director
  add_value_link   msg.link
  add_value_actors msg.actors.slice(0,10)
  add_value_imdb_rating msg.imdb_rating

add_value_year = (year = "") ->
  $('#video_year').val(year)
  $('#select2-chosen-2').text(year)
  $('a.select2-choice').removeClass("select2-default")
  $('.select2-hidden-accessible:last').text(year)
add_value_director = (director = "") ->
  $('#video_director_name').val(director)
add_value_link = (link = "") ->
  $('#video_link').val(link)
add_value_actors = (actors = "") ->
  $('#video_actors').val(actors)
add_value_imdb_rating = (imdb_rating = "") ->
  $('#video_imdb_rating').val(imdb_rating)
add_value_genres = (genres = "") ->
  $('#video_genre_ids option').filter ->
      genres.indexOf($(this).text()) >= 0
    .prop('selected', true)
  $('ul.select2-choices .select2-search-choice').remove()
  $.each(genres, (i, item) ->
    $('ul.select2-choices').prepend('<li class="select2-search-choice"><div>' + genres[i] +
        '</div><a class="select2-search-choice-close" tabindex="-1" href="#"></a></li>')
  )