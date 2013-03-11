#encoding: utf-8
class UsersController < ApplicationController

	#before_filter :save_login_state, :only => [:new, :create]
	before_filter :authenticate_user, :only => [:index]



	def index
		@users = User.all
	end



	def new
		@user = User.new 
	end



	def create
		@user = User.new(params[:user])
		@user.utype = 0
		
		if @user.save
			flash[:notice] = "Usuario creado de manera exitosa. Haga Sign In."
		else
			flash[:error] = "Sus datos no son válidos."
		end

		redirect_to(root_path)
	end



	def show
	  @user = User.find(params[:id])
	end



	def edit
	  @user = User.find(params[:id])
	end



	def update
		@user = User.find(params[:id])
		 
		if @user.update_attributes(params[:user])
			flash[:notice] = 'El usuario fue actualizado de manera correcta.'
	    else
	    	flash[:error] = "No se pudieron actualizar los datos del usuario."
	    end

	    redirect_to(@user)
	end


	def destroy
	  @user = User.find(params[:id])
	  @user.destroy

	  redirect_to :action => 'index'
	end
end