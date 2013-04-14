#encoding: utf-8
class ExamsController < ApplicationController

	before_filter :authenticate_user

	def index
		if check_admin
			@exams = MasterExam.all
			if @exams == nil
				flash[:notice] = 'No hay exámenes que mostrar'
			end
		else
			flash[:error] = "Usted necesita ser un administrador para accesar esta página."
			redirect_to(root_path)
		 end
	end

	def pending
		@exams = MasterExam.where("user_id = ? AND startDate < ? AND finishDate > ? AND attempts > ?", @current_user.id.to_s, Date.today, Date.today, 0)
		if @exams == nil
			flash[:error] = 'No hay exámenes que mostrar'
		end
	end

	def show
		if check_admin
			@exam = Exam.createInstance(params[:id])
		else
			@exam = Exam.createInstance(params[:id])

			@questions = Question.where("exam_id = ?", params[:id])
			
			#Modificar el estado del master exam de dicho usuario
			# @masterExam = MasterExam.find(params[:id])
			#Disminuir un intento cuando se entra al examen
			# @masterExam.attempts = @masterExam.attempts - 1;
		end
	end

	def update
		@exam = Exam.find(params[:id])
	 
		if @group.update_attributes(params[:exam])
			flash[:notice] = 'El exámen fue registrado de manera correcta.'
	    else
	    	flash[:error] = "Error al guardar el exámen."
	    	#Regresar el intento?
	    end

	    redirect_to(user_path)
	end
end
