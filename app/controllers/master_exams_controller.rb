#encoding: utf-8
class MasterExamsController < ApplicationController

	before_filter :authenticate_user, :only => [:index, :new, :create]

	def index
		if check_admin or check_prof
			@meds = MasterExam.all
		else
			flash[:error] = "Usted necesita ser un administrador o profesor para ver todos los exámenes definidos."
			redirect_to(root_path)
		end
	end



	def new
		@med = MasterExam.new
	end



	def create
		@med = MasterExam.new(params[:master_exam])
		@med.user = @current_user
		puts @current_user
		@med.dateCreation = Time.now
		
		if @med.save!
			flash[:notice] = "Examen maestro definido correctamente."
			redirect_to(master_exams_path)
		else
			flash[:error] = "Datos del examen maestro no válidos."
			redirect_to(new_master_exam_path)
		end
	end


	def show
		@med = MasterExam.find(params[:id])
	end


	def edit
		@med = MasterExam.find(params[:id])
	end


	def update
		@med = MasterExam.find(params[:id])
	 
		if @med.update_attributes!(params[:master_exam])
			flash[:notice] = 'El examen maestro fue actualizada de manera correcta.'
	    else
	    	flash[:error] = "No se pudieron actualizar los datos del examen maestro."
	    end

	    redirect_to(@med)
	end


	def destroy
		@med = MasterExam.find(params[:id])
		@med.destroy

		redirect_to :action => 'index'
	end

end
