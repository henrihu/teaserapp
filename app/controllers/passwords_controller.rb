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
    @user = User.find_by_reset_password_token(params[:reset_password_token])
    if @user.reset_password_sent_at > Time.zone.now + 8.hours and params[:password] == params[:password_confirmation]
       @user.reset_password_token = nil
       render :json => {
                          :response_code => 400,
                          :response_message => "You can't access this page without coming from a password reset email. If you do come from a password reset email, please make sure you used the full URL provided."         
                       }
    elsif @user.update_attributes!(permitted_params)
      @user.reset_password_token = nil
      @user.save
      render :json => {
                        :response_code => 200,
                        :response_message => "Your password was changed successfully. You are now signed in."             
                      }
    else
      render :json => {
                        :response_code => 0,
                        :response_message => "cant change #{@user.errors}"   
                      }
    end
  end 
  def permitted_params
    params.require(:user).permit!
  end
	
end
