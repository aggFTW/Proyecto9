#encoding: utf-8
class ExamsController < ApplicationController

	helper_method :who_cantake_masterExam

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
		@masterExams = Array.new
		@attempts = Array.new

		# Se obtienen los examenes cuya fecha de inicio sea menor a la actual y fecha de termino sea mayor a la actual
		availableExams = MasterExam.where("startDate < ? AND finishDate > ?", Date.today, Date.today)
		
		# Para cada uno de estos examenes, se agrega el master exam y los intentos actuales a los arreglos correspondientes
		availableExams.each do |masterExam|
			# Se obtienen los usuarios relacionados con este examen
			validUsers = who_cantake_masterExam(masterExam.id)
			# Se valida que el usuario actual sea un usuario valido y que haya intentos restantes
			if validUsers.include?(@current_user.id) and Exam.where("master_exam_id = ? and user_id = ?", masterExam.id, @current_user.id).size < masterExam.attempts
				@masterExams.push(masterExam)
				# Se agrega a la lista de intentos, la cantidad de intentos del examen encontrado
				@attempts.push(Exam.where("master_exam_id = ? and user_id = ?", masterExam.id, @current_user.id).size)
			end
		end
	end

	def create
		masterExam = MasterExam.find(params[:id])
		@attempts = Exam.where("master_exam_id = ? and user_id = ?", params[:id], @current_user.id).size
		validUsers = who_cantake_masterExam(masterExam.id)

		if check_admin
			# El admin no va a tener examenes, se tiene que implementar algo para que 
			# envie el id del usuario cuyo examen quiere ver, de lo contrario, si sabe
			# el numero de exam se puede ir directamente a show
			
			# Codigo provisional para pruebas

			# Se crea una instancia del examen para el usuario actual
			exam = Exam.createInstance(params[:id],@current_user.id)
			if exam != nil
				# Se muestra el examen
				redirect_to :action => "edit", :id => exam.id
			elsif @attempts >= masterExam.attempts
				flash[:notice] = "Numero de intentos excedido."
				redirect_to(exams_path)
			else
				flash[:error] = "Error al crear el exámen. Intentos actuales: "+@attempts.to_s+"."
				redirect_to(exams_path)
			end
		elsif validUsers.include?(@current_user.id)
			# Se crea una instancia del examen para el usuario actual
			exam = Exam.createInstance(params[:id],@current_user.id)
			if exam != nil
				# Redirigir a editar el examen para contestarlo
				redirect_to :action => "edit", :id => exam.id
			elsif @attempts >= masterExam.attempts
				flash[:notice] = "Numero de intentos excedido."
				redirect_to(pending_path)
			else
				flash[:error] = "Error al crear el exámen. Intentos actuales: "+@attempts.to_s+"."
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


	def edit
		# Se verifica que el administrador sea el que está editando o que el examen sea del usuario actual y que el estado del examen sea 0 (creado)
		if check_admin || (@current_user.id.to_i == Exam.find(params[:id]).user_id.to_i && Exam.find(params[:id]).state.to_i == 0)
			# Declarar el examen como comenzado
			@exam = Exam.find(params[:id])
			# Se guarda el examen para cambiarse a comenzado
			if !@exam.save
				flash[:error] = "Error al obtener el examen."
				redirect_to(pending_path)
			end
		else
			flash[:error] = "Acceso restringido. estado es "+Exam.find(params[:id]).state.to_i.to_s
			redirect_to(pending_path)
		end
	end


	def show
		if check_admin || @current_user.id == Exam.find(params[:id]).user_id
			@exam = Exam.find(params[:id])
		else
			flash[:error] = "Acceso restringido."
			redirect_to(pending_path)
		end
	end

	def update
		if check_admin || @current_user.id == Exam.find(params[:id]).user_id
			@exam = Exam.find(params[:id])
			score = 0

			masterExamId = @exam.master_exam_id

			# Para cada pregunta, se verifica la respuesta
			@exam.questions.each do |question|

				masterQuestionId = question.master_question_id
				questionId = params[":questions"][question.id.to_s]
				givenAns = questionId["givenAns"]
				question.update_attributes(givenAns: givenAns)

				# Si la respuesta dada es correcta, se agrega la cantidad al score
				if givenAns == question.correctAns
					questionNum = question.questionNum
					examDef = ExamDefinition.where("master_exam_id = ? and master_question_id = ? and questionNum = ?", masterExamId, masterQuestionId, questionNum).first
					weight = examDef.weight
					score = score + weight*100
				end
			end

			# Se actualiza el score del examen
		    if @exam.update_attributes(score: score)
				flash[:notice] = 'El exámen fue registrado de manera correcta.'
		    else
		    	flash[:error] = "Error al guardar el exámen."
		    	redirect_to(pending_path)
		    end
		    	redirect_to :action => "results", :id => @exam.id
		else
			flash[:error] = "Usted sólo puede actualizar datos propios."
			redirect_to(pending_path)
		end
	end

	def results
		exam = Exam.find(params[:id])
		validUsers = Array.new
		validUsers.push(exam.user_id)

		masterExam = MasterExam.find(exam.master_exam_id)
		examCreator = masterExam.user_id

		validUsers.push(examCreator)


		if check_admin || validUsers.include?(@current_user.id)
			@exam = exam
		else
			flash[:error] = "Usted sólo puede actualizar datos propios."
			redirect_to(pending_path)
		end
	end

	#gets a list of users that can take the masterExam
	def who_cantake_masterExam(masterExamId)
		validUsers = Array.new

		masterExam = MasterExam.find(masterExamId)
		masterExam.cantakes.each do |cantake|
			validUsers.push(cantake.user_id) 
		end
		validUsers
	end

	def get_exams
		@exams = MasterExam.where(user_id: session[:user_id]).select("id, name, dateCreation").order("dateCreation DESC")
	    respond_to do |format|
	      format.json { render json: @exams.to_json }
	    end
  	end

  	
end
