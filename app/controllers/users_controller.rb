class UsersController < ApplicationController
  before_action :find_user, :except => [:create, :facebook_login]
	
	def create
		params[:password_confirmation] = params[:password]
		@user = User.new(permitted_params)
    if @user.save
        render :json => {
        	                :response_code => 200,
        	                :response_message => "You've signed up successfully.",
                          :user_id => @user.id
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
		if @user
			@user.update_attributes(permitted_params)
    else
      @user = User.create(permitted_params) 
		end	
		render :json => {
    	                :response_code => 200,
    	                :response_message => "You've logged in successfully.",
                      :user_id => @user.id
        	          }
	end	

	def all_genres
	  render :json => {
    	                :response_code => 200,
    	                :response_message => "Genres has been successfully fetched.",
                      :genres => Genre.all
        	          }
                 
	end	

	def genre_video
		@genre = Genre.find(params[:genre_id])
		videos = Array.new
		@genre.videos.each do |video|
			videos << video.attributes.except("created_at", "updated_at", "genre_id").merge(:genre_name => video.genre.name)
		end	
		if @genre
			render :json => {
    	                :response_code => 200,
    	                :response_message => "Genres has been successfully fetched.",
                      :videos => videos
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
		videos = Array.new
		@videos = Video.limit(10).order('RANDOM()')
		@videos.each do |video|
			videos << video.attributes.except("created_at", "updated_at", "genre_id").merge(:genre_name => video.genre.name)
		end
		unless @videos.blank?
			render :json => { 
                        :response_code => 200,
                        :response_message => "Videos has been fetched successfully.",
                        :videos => videos
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
				@videos << video.attributes.except("created_at", "updated_at", "genre_id").merge(:genre_name => video.genre.name)
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

  def permitted_params
    params.permit(:email, :name, :password, :password_confirmation, :age, :gender, :reset_password_token, :payment_status)
  end
end
