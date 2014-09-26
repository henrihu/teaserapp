class SessionsController < ApplicationController
	
	def create
    @user = User.find_by_email(params[:email])
    if @user and @user.authenticate(params[:password])
  		render :json => {  
    	  	               :response_code => 200,
        	               :response_message => "You've signed in successfully.",
        	               :user => @user
        	            }
  	else
  		render :json => {  
    	  	               :response_code => 500,
        	               :response_message => "Unauthorised access."
        	            }
  	end	
  end

  def destroy
    @user = User.find(params[:user_id])
    if @user
      render :json => {
  			                :response_code => 200,
  			                :response_message => "You've successfully logged out."

  		                }
  	else
  	  render :json => {
  			                :response_code => 500,
  			                :response_message => "Please login first."
                      }
  	end	                	                
  end	

  def permitted_params
  	params.permit(:email, :password, :username)
  end   
end
