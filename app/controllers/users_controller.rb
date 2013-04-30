#encoding: utf-8
class UsersController < ApplicationController

	#before_filter :save_login_state, :only => [:new, :create]
	before_filter :authenticate_user, :only => [:index, :show, :edit, :update, :destroy]

	def index
		if check_admin
			@users = User.all
		else
			flash[:error] = "Usted necesita ser un administrador para accesar esta página."
			redirect_to(root_path)
		end
	end

	def new
		@user = User.new
	end

	def signup
		if session[:user_id].nil?
			@user = User.new
		else
			user = User.find session[:user_id]
			redirect_to(user)
		end
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
		if check_admin || @current_user.id.to_s == params[:id]
			@user = User.find(params[:id])
		else
			flash[:error] = "Usted sólo puede ver datos propios."
			redirect_to(root_path)
		end
	end

	def edit
		if check_admin || @current_user.id.to_s == params[:id]
			@user = User.find(params[:id])
		else
			flash[:error] = "Usted sólo puede editar datos propios."
			redirect_to(root_path)
		end
	end

	def update
		if check_admin || @current_user.id.to_s == params[:id]
			@user = User.find(params[:id])
		 
			if @user.update_attributes(params[:user])
				flash[:notice] = 'El usuario fue actualizado de manera correcta.'
		    else
		    	flash[:error] = "No se pudieron actualizar los datos del usuario."
		    end

		    redirect_to(@user)
		else
			flash[:error] = "Usted sólo puede actualizar datos propios."
			redirect_to(root_path)
		end
	end

	def destroy
		if check_admin
			@user = User.find(params[:id])
			@user.destroy

			redirect_to :action => 'index'
		else
			flash[:error] = "Debe ser administrador para borrar usuarios."
			redirect_to(root_path)
		end
	end

	def get_users
		if check_admin || @current_user.id.to_s == params[:id]
			@users = User.all
		    respond_to do |format|
		      format.json { render json: @users.to_json }
		    end
		end
	end	

	def get_current_user
		respond_to do |format|
			format.json { render json: session[:user_id].to_json }
		end
	end

	def transmit_UserId
	    user_id = session[:user_id]
	    respond_to do |format|
	      format.json { render json: user_id.to_json }
	    end
	end
end