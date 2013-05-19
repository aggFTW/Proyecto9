#encoding: utf-8
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
    #este no debería de ir aquí pero marca error al intentarlo hacer en otro controlador
    #parece que una vez que hago un get en este controlador, ya no puedo cambiarlo.
    #por lo tanto los queries los voy a hacer aquí
    hash = params[:hash]
    exam_name = params[:exam_name]
    number_of_attempts = params[:number_of_attempts]
    creationYear = params[:creationYear].to_i
    creationMonth = params[:creationMonth].to_i
    creationDay = params[:creationDay].to_i
    creationHour = params[:creationHour].to_i
    creationMinute = params[:creationMinute].to_i
    startYear = params[:startYear].to_i
    startMonth = params[:startMonth].to_i
    startDay = params[:startDay].to_i
    startHour = params[:startHour].to_i
    startMinute = params[:startMinute].to_i
    endYear = params[:endYear].to_i
    endMonth = params[:endMonth].to_i
    endDay = params[:endDay].to_i
    endHour = params[:endHour].to_i
    endMinute = params[:endMinute].to_i

    user = User.find_by_id session[:user_id]
    master_exam = MasterExam.create(
      attempts: number_of_attempts,
      name: exam_name,
      dateCreation: Time.strptime("#{creationYear}-#{creationMonth}-#{creationDay} #{creationHour}:#{creationMinute}", '%Y-%m-%d %H:%M').in_time_zone(Time.zone),
      startDate: Time.strptime("#{startYear}-#{startMonth}-#{startDay} #{startHour}:#{startMinute}", '%Y-%m-%d %H:%M').in_time_zone(Time.zone),
      finishDate: Time.strptime("#{endYear}-#{endMonth}-#{endDay} #{endHour}:#{endMinute}", '%Y-%m-%d %H:%M').in_time_zone(Time.zone),
      user: user
    )
    
    $i = 1
    hash.each do |key, value|
      w = hash[key]['value'].to_f
      ExamDefinition.create( 
        master_question: MasterQuestion.find_by_id( hash[key]['master_question_id'].to_i ),
        master_exam: MasterExam.find_by_id(master_exam.id),
        questionNum: $i, 
        weight: w 
      )
      $i+=1
    end

    flash[:notice] = "Examen agregado exitosamente"

    respond_to do |format|
      format.json { render json: hash.to_json }
    end
	end
end