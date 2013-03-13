#encoding: utf-8
class SessionsController < ApplicationController

  # before_filter :authenticate_user, :only => [:home, :profile, :setting]
  # before_filter :save_login_state, :only => [:login]

  def login
  	authorized_user = User.authenticate(params[:gusername],params[:gspassword])

  	if authorized_user
  		session[:user_id] = authorized_user.id
  		flash[:notice] = "Bienvenido #{authorized_user.fname} #{authorized_user.lname}."
  		redirect_to(root_path)
  	else
  		flash[:error] = "Usuario o password inválidos."
  		redirect_to(root_path)
  	end
  end

  # def home
  # end

  # def profile
  # end

  # def setting
  # end

  def logout
  	session[:user_id] = nil
  	redirect_to(root_path)
  end

end
