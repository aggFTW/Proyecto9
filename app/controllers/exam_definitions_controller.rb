#encoding: utf-8
class ExamDefinitionsController < ApplicationController

	# before_filter :authenticate_user, :only => [:index, :new, :create]

	def index
		if check_admin or check_prof
			@eds = ExamDefinition.all
		else
			flash[:error] = "Usted necesita ser un administrador o profesor para ver todos los exámenes definidos."
			redirect_to(root_path)
		end
	end



	def new
		@ed = ExamDefinition.new
	end



	def create
		@ed = ExamDefinition.new(params[:exam_definition])
		
		if @ed.save
			flash[:notice] = "Pregunta agregada a definición de manera exitosa."
			redirect_to(exam_definitions_path)
		else
			flash[:error] = "Datos de la pregunta o examen maestro no válidos."
			redirect_to(new_exam_definition_path)
		end
	end


	def show
		@ed = ExamDefinition.find(params[:id])
	end


	def edit
		@ed = ExamDefinition.find(params[:id])
	end


	def update
		@ed = ExamDefinition.find(params[:id])
	 
		if @ed.update_attributes!(params[:exam_definition])
			flash[:notice] = 'La pregunta del examen maestro fue actualizada de manera correcta.'
	    else
	    	flash[:error] = "No se pudieron actualizar los datos de la pregunta."
	    end

	    redirect_to(@ed)
	end


	def destroy
		@ed = ExamDefinition.find(params[:id])
		@ed.destroy

		redirect_to :action => 'index'
	end

end
