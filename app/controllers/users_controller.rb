class UsersController < ApplicationController
  before_action :find_user, :except => [:create, :facebook_login]
	
	def create
		params[:password_confirmation] = params[:password]
		@user = User.new(permitted_params)
    if @user.save
        render :json => {
        	                :response_code => 200,
        	                :response_message => "You've signed up successfully.",
                          :user_id => @user.id,
                          :payment_status => @user.payment_status
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
                      :user_id => @user.id,
                      :payment_status => @user.payment_status
        	          }
	end	

	def all_genres
	  render :json => {
    	                :response_code => 200,
    	                :response_message => "Genres has been successfully fetched.",
                      :genres => Genre.all.as_json(only: [:id, :name])
        	          }
                 
	end	

	def genre_video
		@genre = Genre.find(params[:genre_id])
		@video = (@genre.videos - @user.videos - @user.histories - @user.favorites).sample
    wideo = @video.attributes.except("created_at", "updated_at").merge!(:genre_name => @video.genres.pluck(:name).join(', '))
	  @user.histories.create(video_id: wideo["id"])
    if wideo
			render :json => {
    	                :response_code => 200,
    	                :response_message => "Genres has been successfully fetched.",
                      :videos => wideo
        	            }
    else
     render :json => {
    	                :response_code => 500,
    	                :response_message => "Genres has been successfully fetched."
                     }
    end    	           
	end	

  def last_video
    wideo = @user.histories.last(2).first.video
    @video = wideo.attributes.except("created_at", "updated_at").merge!(:genre_name => wideo.genres.pluck(:name).join(', '))
    if @video
      render :json => {
                      :response_code => 200,
                      :response_message => "Genres has been successfully fetched.",
                      :videos => @video
                      }
    else
     render :json => {
                      :response_code => 500,
                      :response_message => "Genres has been successfully fetched."
                     }
    end    
  end  


	def starred_videos
		@video = Video.find(params[:video_id])
		favorite = @video.favorites.create(user_id: @user.id)
		if favorite
			render :json => { 
                        :response_code => 200,
                        :response_message => "Videos has been starred successfully."
                      }
		else
			render :json => { 
                        :response_code => 500,
                        :response_message => "Videos doesn't exist."
                      }
		end	
	end	

	def random_video
		video = (Video.all - @user.videos - @user.histories - @user.favorites).sample
		wideo = video.attributes.except("created_at", "updated_at", "genre_id").merge!(:genre_name => video.genres.pluck(:name).join(', '))
    unless wideo.nil?
			render :json => { 
                        :response_code => 200,
                        :response_message => "Videos has been fetched successfully.",
                        :videos => wideo
                      }
		else
			render :json => { 
                        :response_code => 500,
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
                        :response_message => "You're aleady subscribed."
                      }
		end

	end	

	def get_starred_videos
		if @user.payment_status == true
			@videos = Array.new 
			videos = Video.find(@user.favorites.pluck(:video_id))
			videos.each do |video|
				@videos << video.attributes.except("created_at", "updated_at", "genre_id").merge(:genre_name => video.genres.pluck(:name).join(', '))
			end	
      render :json => { 
                        :response_code => 200,
                        :response_message => "Videos has been successfully fetched.",
                        :videos => @videos
                      }

		else
			render :json => { 
                        :response_code => 500,
                        :response_message => "Please purchase the premium version."
                      }
    end                  
			
	end	

  def seen_video
    @video = Video.find(params[:video_id])
    if @video
      @user.users_videos.create(video_id: @video.id)
      render :json => { 
                        :response_code => 200,
                        :response_message => "You've seen this video."
                      }
    else
      render :json => { 
                        :response_code => 500,
                        :response_message => "Video doesn't exist."
                      }
    end  
  end 

  def delete_starred_video
    video = @user.favorites.find_by(video_id: params[:video_id])
    if video.destroy
      render :json => { 
                        :response_code => 200,
                        :response_message => "Video has been removed from your starred list."
                      }
    else
      render :json => { 
                        :response_code => 500,
                        :response_message => "Yuo're not authorized to do it."
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
