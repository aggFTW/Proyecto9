class SessionsController < ApplicationController

  before_filter :authenticate_user, :only => [:home, :profile, :setting]
  # before_filter :save_login_state, :only => [:login]

  def login
  	authorized_user = User.authenticate(params[:gusername],params[:gspassword])

	if authorized_user
		session[:user_id] = authorized_user.id
		flash[:notice] = "Wow Welcome again, you logged in as #{authorized_user.username}"
		redirect_to(root_path)
	else
		flash[:error] = "Invalid Username or Password"
		redirect_to(root_path)
	end
  end

  def home
  end

  def profile
  end

  def setting
  end

  def logout
	session[:user_id] = nil
	redirect_to(root_path)
  end

end
