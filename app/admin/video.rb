ActiveAdmin.register Video do

  collection_action :imdb_title, method: :get do
    if !(params[:id].blank?)
      s = Imdb::Movie.new(params[:id])
      if s.title.nil?
        render json: {message: "Not Found Movie"} , status: 403
      else
        render json: {id: s.id, name: s.title, genres: s.genres, year: s.year, director: s.director, \
                    link: s.url, actors: s.cast_members , imdb_rating: s.rating}, status: 200
      end
    elsif !(params[:search].blank?)
      s =  Imdb::Search.new(params[:search])
      s_len = s.movies.size
      if s_len == 0
        render json: {message: "Not Found Movie"}, status: 403
      else
        s_id_title  = s.movies.map{|m| [m.id, m.title]}
        render json: {search: params[:search], length: s_len, id_title: s_id_title} , status: 200
      end
    else
      render json: {message: "Not Found any params"}, status: 400
    end
  end

  batch_action :destroy do |selection|
    Video.find(selection).each do |video|
      video.destroy
    end
    redirect_to admin_videos_path, :alert => "Videos has been deleted successfully."
  end

  filter :name
  filter :genre


  form do |f|
    f.inputs "Video" do
      f.input :name, as: :select
      f.input :genre_ids, :label => "Genre", as: :select, multiple: true, :collection => Genre.all.map{ |genre| [genre.name, genre.id] }, :prompt => 'Select one'
      f.input :year, :as => :select, :collection => (1900..Time.now.year).to_a
      f.input :director_name
      f.input :link
      f.input :actors
      f.input :imdb_rating, as: :string, :placeholder => "Out of 10"
      f.input :rotten_tomatoes_rating, as: :string, :placeholder => "Out of 100"
    end
    f.actions
  end
  
  index :download_links => false do
    selectable_column
    column :name
    #column :genre
    column "Actions" do |video|  
      a do                                                         
        link_to 'View', admin_video_path(video)
      end
      a do
        link_to 'Edit', edit_admin_video_path(video)
      end
      a do
        link_to 'Delete', admin_video_path(video), method: :delete, :data => { :confirm => 'Are you sure, you want to delete this video?' }     
      end
    end
  end

  show do |ad|
    attributes_table do
      row :name
      row 'Genres' do |video|
        raw(video.genres.map { |genre| link_to genre.name, admin_genre_path(genre) }.join(', '))
      end
      row :actors
      row :imdb_rating
      row :rotten_tomatoes_rating    
      row :director_name
      row "Link" do
        link_to ad.link, ad.link, target: '_blank'  
      end  
      row :year
      row "Created On" do
        ad.created_at
      end
    end
  end



  controller do
    def permitted_params 
      params.permit video: [:name, :year, :link, :director_name, :imdb_rating, :rotten_tomatoes_rating, :actors, :genre_ids => []]
    end
  end
end  
