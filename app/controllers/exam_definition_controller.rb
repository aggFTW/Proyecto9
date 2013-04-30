class ExamDefinitionController < ApplicationController
	def new
		@examDefinition = ExamDefinition.new
		@master_questions = MasterQuestion.all_languages
		@examUsers = nil
	end

	def create
		@examDefinition = ExamDefinition.new(params[:examID])
		@examDefinition.utype = 0
		
		if @examDefinition.save
			flash[:notice] = "Definición de examen creada de manera exitosa."
		else
			flash[:error] = "Los datos no son válidos."
		end

		redirect_to root_path
	end

	def edit
		@exams = MasterExam.where(user_id: session[:user_id]).select("name, dateCreation")
		@groups = Group.where(user_id: session[:user_id]).select("name")
		@users = User.all
	end

	def update
	end

	def destroy
	end

	def index
	end

	def exam_def 
	end


	def get_exams
		@exams = MasterExam.where(user_id: session[:user_id]).select("name, dateCreation")
	    respond_to do |format|
	      format.json { render json: @exams.to_json }
	    end
  	end
  	def get_groups
		@groups = Group.where(user_id: session[:user_id]).select("name")
	    respond_to do |format|
	      format.json { render json: @groups.to_json }
	    end
  	end
  	def get_users
		@users = User.all
	    respond_to do |format|
	      format.json { render json: @users.to_json }
	    end
  	end
  	def get_current_user
  		respond_to do |format|
  			format.json { render json: session[:user_id].to_json }
  		end
  	end
end