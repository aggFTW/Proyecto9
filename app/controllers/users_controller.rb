class UsersController < ApplicationController

	#before_filter :save_login_state, :only => [:new, :create]

	def new
		@user = User.new 
	end

	def create
		@user = User.new(params[:user])
		@user.utype = 0
		
		if @user.save
			flash[:notice] = "Usuario creado de manera exitosa. Haga Sign In."
		else
			flash[:error] = "Sus datos no son validos."
		end

		redirect_to(root_path)
	end
end