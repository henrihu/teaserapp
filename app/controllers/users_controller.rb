class UsersController < ApplicationController
  before_action :find_user, :except => [:create, :facebook_login]
	
	def create
		params[:password_confirmation] = params[:password]
		@user = User.new(permitted_params)
    if @user.save
        render :json => {
        	                :response_code => 200,
        	                :response_message => "You've signed up successfully.",
                          :user => @user.attributes.merge!(facebook_login: false, starred_videos: @user.my_favorites)
        	              }
    else
    	  render :json => {  
    	  	                :response_code => 500,
        	                :response_message => @user.errors.full_messages.first
        	              }
    end	
	end

	def facebook_login
		@user = User.find_by_email(params[:email])
    params[:age] = find_age(params[:age])
    if @user
      @user.update_attributes(permitted_params)
    else
      params[:password_confirmation] = params[:password] = Random.new.bytes(8).bytes.join[0,8]
      @user = User.create(permitted_params) 
		end	
		render :json => {
    	                :response_code => 200,
    	                :response_message => "You've logged in successfully.",
                      :user => @user.attributes.merge!(facebook_login: true, starred_videos: @user.my_favorites)
        	          }
	end	

	def all_genres
    @genres = Array.new
    genres = Genre.all.sort_by{|x| x.name}
    genres.each{|g| @genres << g.attributes.except("created_at", "updated_at").merge!(image: g.avatar_url)}
	  render :json => {
    	                :response_code => 200,
    	                :response_message => "Genres has been successfully fetched.",
                      :genres => @genres#.as_json(only: [:id, :name, :image])
        	          }
                 
	end	

	def genre_video
		@genre = Genre.find(params[:genre_id])
    @user.histories.destroy_all if params[:first_time] == 1
		@video = (@genre.videos - @user.videos - @user.my_histories).sample
    unless @video.nil?
      stats = @user.my_favorites.include? @video
      wideo = @video.attributes.except("created_at", "updated_at").merge!(:genre_name => @video.genres.pluck(:name).join(', '), last_video: false, :starred_status => stats )
  	  history = History.find_by(user_id: @user.id, video_id:  wideo["id"])
      @user.histories.create(video_id: wideo["id"])
      history.destroy unless history.nil?
      render :json => {
    	                  :response_code => 200,
    	                  :response_message => "Genres has been successfully fetched.",
                        :videos => wideo
        	            }
    else
      render :json => {
    	                  :response_code => 500,
    	                  :response_message => "No more videos available for this genre."
                      }
    end    	           
	end	

  def last_video
    index = params[:history_id] + 1
    wideo = @user.histories.last(index).first.video
    status = false ||  index == @user.histories.count
    stats = @user.my_favorites.include? wideo
    @video = wideo.attributes.except("created_at", "updated_at").merge!(:genre_name => wideo.genres.pluck(:name).join(', '), last_video: status, :starred_status => stats)
    if @video
      render :json => {
                        :response_code => 200,
                        :response_message => "Genres has been successfully fetched.",
                        :videos => @video
                      }
    else
     render :json => {
                      :response_code => 500,
                      :response_message => "No history available."
                     }
    end    
  end  


	def starred_videos
		@video = Video.find(params[:video_id])
		favorite = @video.favorites.create(user_id: @user.id)
		if favorite
			render :json => { 
                        :response_code => 200,
                        :response_message => "Videos has been starred successfully.",
                        :starred_videos => @user.my_favorites
                      }
		else
			render :json => { 
                        :response_code => 500,
                        :response_message => "Videos doesn't exist."
                      }
		end	
	end	

	def random_video
    @user.histories.destroy_all if params[:first_time] == 1
		video = (Video.all - @user.videos - @user.my_histories).sample
    unless video.nil?
    stats = @user.my_favorites.include? video
    last_video = (Video.all - @user.videos - @user.my_histories).length == 1
		wideo = video.attributes.except("created_at", "updated_at", "genre_id").merge!(:genre_name => video.genres.pluck(:name).join(', '), :starred_status => stats, :last_video => last_video)
      @user.histories.create(video_id: wideo["id"])
			render :json => { 
                        :response_code => 200,
                        :response_message => "Videos has been fetched successfully.",
                        :videos => wideo
                      }
		else
			render :json => { 
                        :response_code => 200,
                        :response_message => "No videos found."
                      }
		end	
	end	

	def paid_version
		if @user.update_attribute(:payment_status, true)
			render :json => { 
                        :response_code => 200,
                        :response_message => "You've subscribed successfully."
                      }
		else
			render :json => { 
                        :response_code => 500,
                        :response_message => "You're already subscribed."
                      }
		end

	end	

	def get_starred_videos
		# if @user.payment_status == true
		# 	@videos = Array.new; videos = Array.new;
  #     @user.favorites.order('created_at DESC').map{|f| videos << f.video}
		#   videos.each do |video|
		# 		@videos << video.attributes.except("created_at", "updated_at", "genre_id").merge(:genre_name => video.genres.pluck(:name).join(', '))
		# 	end	
  #     render :json => { 
  #                       :response_code => 200,
  #                       :response_message => "Videos has been successfully fetched.",
  #                       :videos => @videos
  #                     }

		# else
		# 	render :json => { 
  #                       :response_code => 500,
  #                       :response_message => "Starring films is available on the paid version, would you like to upgrade?"
  #                     }
  #   end                  
		@videos = Array.new; videos = Array.new;
      @user.favorites.order('created_at DESC').map{|f| videos << f.video}
      videos.each do |video|
        @videos << video.attributes.except("created_at", "updated_at", "genre_id").merge(:genre_name => video.genres.pluck(:name).join(', '))
      end 
      render :json => { 
                        :response_code => 200,
                        :response_message => "Videos has been successfully fetched.",
                        :videos => @videos
                      }	
	end	

  def seen_video
    @video = Video.find(params[:video_id])
    @seen_video = @user.videos.include? @video
    if @video and !@seen_video
      @user.users_videos.create(video_id: @video.id)
      history = History.find_by(user_id: @user.id, video_id: @video.id)
      starred = @user.favorites.find_by_video_id(@video.id)
      starred.destroy unless starred.nil?
      history.destroy unless history.nil?
      render :json => { 
                        :response_code => 200,
                        :response_message => "You've seen this video."
                      }
    else
      render :json => { 
                        :response_code => 500,
                        :response_message => "You've already seen this video."
                      }
    end  
  end 

  def delete_starred_video
    video = @user.favorites.find_by(video_id: params[:video_id])
    if video.destroy
      render :json => { 
                        :response_code => 200,
                        :response_message => "Video has been removed from your starred list.",
                        :starred_videos => @user.my_favorites
                      }
    else
      render :json => { 
                        :response_code => 500,
                        :response_message => "You're not authorized to do it."
                      }
    end  
  end 

  def erase_seen_videos
    if @user.videos.destroy_all
      render :json => { 
                        :response_code => 200,
                        :response_message => "Seen films were successfully cleared."
                      }
    else
      render :json => { 
                        :response_code => 500,
                        :response_message => "Sorry! no seen videos available."
                      }
    end                  
  end  


  private
  def find_user
    @user = User.find_by_id(params[:user_id]) 
    unless @user
      render :json => { 
                        :response_code => 404,
                        :response_message => "User doesn't exist."
                      }
    end
  end

  def find_age date
    date_values = date.split('/').collect{|s| s.to_i}
    return (Time.now.to_date - Date.new(date_values[2],date_values[0],date_values[1]))/365
  end

  def permitted_params
    params.permit(:email, :name, :password, :password_confirmation, :age, :gender, :reset_password_token, :payment_status, :genre_name, :id)
  end
end
