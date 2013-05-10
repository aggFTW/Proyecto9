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
    creationYear = params[:creationYear]
    creationMonth = params[:creationMonth]
    creationDay = params[:creationDay]
    creationHour = params[:creationHour]
    creationMinute = params[:creationMinute]
    startYear = params[:startYear]
    startMonth = params[:startMonth]
    startDay = params[:startDay]
    startHour = params[:startHour]
    startMinute = params[:startMinute]
    endYear = params[:endYear]
    endMonth = params[:endMonth]
    endDay = params[:endDay]
    endHour = params[:endHour]
    endMinute = params[:endMinute]

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
    hash.each do |h|
      w = h[1]['value'].to_f
      ExamDefinition.create( 
        master_question: MasterQuestion.find_by_id( h[1]['master_question_id'][$i-1] ), 
        master_exam: MasterExam.find_by_id(master_exam.id),
         questionNum: $i, 
        weight: w 
      )
      $i+=1

    end
    flash.now[:notice] = "Examen agregado exitosamente"

    respond_to do |format|
      format.json { render json: hash.to_json }
    end
    redirect_to(def_path)
	end
end