#encoding: utf-8
class ExamsController < ApplicationController

	helper_method :who_cantake_masterExam

	before_filter :authenticate_user, :except => [:who_cantake_masterExam]

	def new
		@exam = Exam.new
	end

	def index
		if check_admin
			@masterExams = MasterExam.all
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		 end
	end

	def pending
		@masterExams = Array.new
		@attempts_exams = Array.new

		@masterExercises = Array.new
		@exer_info = Array.new

		# Se obtienen los examenes cuya fecha de inicio sea menor a la actual y fecha de termino sea mayor a la actual
		# Además, estos deben ser creados por personas diferentes al usuario actual
		availableExams = MasterExam.where("startDate < ? AND finishDate > ? AND user_id <> ?", Date.today, Date.today, @current_user.id)
		
		# Para cada uno de estos examenes, se agrega el master exam y los intentos actuales a los arreglos correspondientes
		availableExams.each do |masterExam|
			# Se obtienen los usuarios relacionados con este examen
			validUsers = who_cantake_masterExam(masterExam.id)
			# Se valida que el usuario actual sea un usuario valido y que haya intentos restantes
			if validUsers.include?(@current_user.id) and Exam.where("master_exam_id = ? and user_id = ?", masterExam.id, @current_user.id).size < masterExam.attempts
				@masterExams.push(masterExam)
				# Se agrega a la lista de intentos, la cantidad de intentos del examen encontrado
				@attempts_exams.push(Exam.where("master_exam_id = ? and user_id = ?", masterExam.id, @current_user.id).size)
			end
		end

		# Se obtienen los examenes (ejercicios) creados por uno mismo, como ejercicios
		availableExercices = MasterExam.where("user_id = ?", @current_user.id)
		
		# Para cada uno de estos examenes, se agrega el master exam y el promedio de los intentos actuales a los arreglos correspondientes
		availableExercices.each do |masterExam|
			# Se obtienen los usuarios relacionados con este examen
			validUsers = who_cantake_masterExam(masterExam.id)
			# Se valida que el usuario actual sea un usuario valido
			if validUsers.include?(@current_user.id)
				actual_exams = Exam.where("master_exam_id = ? and user_id = ?", masterExam.id, @current_user.id)
				@masterExercises.push(masterExam)
				if actual_exams.length > 0
					grade = actual_exams.map { |e| e.score }.inject{|sum,x| sum + x }
					grade = grade / actual_exams.length.to_f
				else
					grade = "-"
				end
				@exer_info.push([grade, actual_exams.length])
			end
		end
	end

	def create
		masterExam = MasterExam.find(params[:id])
		creatorId = masterExam.user_id
		available = false
		if creatorId == @current_user.id
			# La fecha de creación no importa, es un ejercicio
			available = true
		else
			#La fecha de creación si importa, es un examen de alguien más
			if masterExam.startDate < Date.today && masterExam.finishDate > Date.today
				available = true
			end
		end
		@attempts = Exam.where("master_exam_id = ? and user_id = ?", params[:id], @current_user.id).size
		validUsers = who_cantake_masterExam(masterExam.id)

		if available && (check_prof || validUsers.include?(@current_user.id))

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
		if check_prof || (@current_user.id.to_i == Exam.find(params[:id]).user_id.to_i && Exam.find(params[:id]).state.to_i == 0)
			# Declarar el examen como comenzado
			@exam = Exam.find(params[:id])
			# Se guarda el examen para cambiarse a comenzado
			if !@exam.save
				flash[:error] = "Error al obtener el examen."
				redirect_to(pending_path)
			end
		else
			flash[:error] = "Acceso restringido."
			redirect_to(pending_path)
		end
	end


	def show
		if check_prof || @current_user.id == Exam.find(params[:id]).user_id
			@exam = Exam.find(params[:id])
		else
			flash[:error] = "Acceso restringido."
			redirect_to(pending_path)
		end
	end

	def update
		if check_prof || @current_user.id == Exam.find(params[:id]).user_id
			@exam = Exam.find(params[:id])
			
			masterExam = @exam.master_exam

			# Checar que la fecha del examen sea valida
			if masterExam.startDate < Date.today && masterExam.finishDate > Date.today
				score = 0
				masterExamId = masterExam.id

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
			    	redirect_to(root_path)
			    end
		    	redirect_to :action => "results", :id => @exam.id
		    else
		    	flash[:error] = "Examen no disponible."
		    	redirect_to(root_path)
		    end
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def results
		exam = Exam.find(params[:id])
		validUsers = Array.new
		validUsers.push(exam.user_id)

		masterExam = MasterExam.find(exam.master_exam_id)
		examCreator = masterExam.user_id

		validUsers.push(examCreator)


		if check_prof || validUsers.include?(@current_user.id)
			@exam = exam
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	#gets a list of users that can take the masterExam
	private
		def who_cantake_masterExam(masterExamId)
			validUsers = Array.new

			masterExam = MasterExam.find(masterExamId)
			masterExam.cantakes.each do |cantake|
				validUsers.push(cantake.user_id) 
			end
			validUsers
		end
 	
end
