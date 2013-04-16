#encoding: utf-8
class ExamsController < ApplicationController

	before_filter :authenticate_user

	def new
		@exam = Exam.new
	end

	def index
		if check_admin
			@masterExams = MasterExam.all
		else
			flash[:error] = "Usted no tiene permisos para accesar esta página."
			redirect_to(root_path)
		 end
	end

	def pending
		@masterExams = MasterExam.where("user_id = ? AND startDate < ? AND finishDate > ? AND state = ?", @current_user.id.to_s, Date.today, Date.today, "0")
	end

	def create
		masterExam = MasterExam.find(params[:id])
		attempts = Exam.where("master_exam_id = ? and user_id = ?", params[:id], session[:user_id]).size
		if check_admin
			# El admin no va a tener examenes, se tiene que implementar algo para que 
			# envie el id del usuario cuyo examen quiere ver, de lo contrario, si sabe
			# el numero de exam se puede ir directamente a show
			
			# Codigo provisional para pruebas
			exam = Exam.createInstance(params[:id],session[:user_id])
			if exam != nil
				redirect_to(exam)
			elsif attempts >= masterExam.attempts
				flash[:notice] = "Numero de intentos excedido."
				redirect_to(exams_path)
			else
				flash[:error] = "Error al crear el exámen. Intentos actuales: "+attempts.to_s+"."
				redirect_to(exams_path)
			end
		elsif session[:user_id] == masterExam.user_id
			exam = Exam.createInstance(params[:id],session[:user_id])
			if exam != nil
				# Declarar el examen como comenzado
				exam.state = 1
				exam.save
				redirect_to(exam)
			elsif attempts >= masterExam.attempts
				flash[:notice] = "Numero de intentos excedido."
				redirect_to(pending_path)
			else
				flash[:error] = "Error al crear el exámen. Intentos actuales: "+attempts.to_s+"."
				redirect_to(pending_path)
			end
			#Modificar el estado del master exam de dicho usuario
			# @masterExam = MasterExam.find(params[:id])
			#Disminuir un intento cuando se entra al examen
			# @masterExam.attempts = @masterExam.attempts - 1;
		else
			flash[:error] = "Exámen no disponible."
			redirect_to(pending_path)
		end
	end

	def show
		if check_admin || @current_user.id == Exam.find(params[:id]).user_id
			@exam = Exam.find(params[:id])
		else
			flash[:error] = "Usted sólo puede ver datos propios."
			redirect_to(pending_path)
		end
	end

	def update
		if check_admin || @current_user.id.to_s == Exam.find(params[:id]).user_id
			@exam = Exam.find(params[:id])
			# Verificar estado de terminado
			@exam.state = 2
			if @exam.update_attributes(params[:exam])
				@exam.questions.each do |question|
					questionId = params[":questions"][question.id.to_s]
					givenAns = questionId["givenAns"]
					question.update_attributes(givenAns: givenAns)
				end
				flash[:notice] = 'El exámen fue registrado de manera correcta.'
		    else
		    	flash[:error] = "Error al guardar el exámen."
		    	#Regresar el intento?
		    end
		    if check_admin
		    	redirect_to(exams_path)
		    else
		    	redirect_to(pending_path)
		    end
		else
			flash[:error] = "Usted sólo puede actualizar datos propios."
			redirect_to(pending_path)
		end
	end
end
