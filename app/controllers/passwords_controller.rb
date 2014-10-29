class PasswordsController < ApplicationController

	def reset_password
		@user = User.find_by(email: params[:email])
		if @user
			@user.send_token
      render :json => { :response_code => 200,
  			                :response_message => 'You will receive a password recovery link at your email address in a few minutes.'
                      } 
    else
    	render :json => { :response_code => 500,
  			                :response_message => "Sorry, User doesn't exist."
                      } 
    end                   
	end	

	def edit_password   
    @user = User.find_by_reset_password_token(params[:reset_password_token])
    if @user.nil?
      respond_to do |format|
        format.html { 
        flash[:notice] = "We're sorry, But this password reset code has been expired. Please request a new one."
        redirect_to index_path 
        }
      end
    end
  end

  def update_password
    if params[:user][:password].present? and params[:user][:password_confirmation].present?
      @user = User.find_by_reset_password_token(params[:reset_password_token])
      if @user.reset_password_sent_at > Time.zone.now + 8.hours
        @user.update_attributes(reset_password_token: nil)
        redirect_to :back, notice: "Your password reset link has been expired." 
      elsif params[:user][:password].eql? (params[:user][:password_confirmation]) 
        @user.update_attributes(password: params[:user][:password], password_confirmation: params[:user][:password_confirmation], reset_password_token: nil)
        redirect_to index_path, notice: "Your password was changed successfully. You are now signed in." 
      else
        redirect_to :back, alert: "Password and confirm password should be identical." 
      end
    else
      redirect_to :back, alert: "Password and confirm password can't be blank." 
    end  
  end 

  def update_profile
    @user = User.find(params[:user_id])
    if @user.authenticate(params[:old_password])
      if params[:password].eql? (params[:password_confirmation])
        @user.update_attributes(password: params[:password], password_confirmation: params[:password_confirmation])
        render :json => {
                        :response_code => 200,
                        :response_message => "Password has been updated successfully."             
                      }
      else
        render :json => {
                        :response_code => 500,
                        :response_message => "Password and confirm password doesn't match."             
                      }
      end
    else
      render :json => {
                        :response_code => 500,
                        :response_message => "Old password doesn't match."        
                      }
    end                  
  end

  def update_fields
    @user = User.find(params[:user_id])
    @user.email = params[:email] if params[:email].present?
    @user.name = params[:name] if params[:name].present?
    if @user.save
      render :json => {
                        :response_code => 200,
                        :response_message => "Your profile has been updated successfully."             
                      }
    else
      render :json => {
                        :response_code => 500,
                        :response_message => @user.errors.full_messages.first         
                      }
    end    
  end  

  def permitted_params
    params.require(:user).permit!
  end
	
end
