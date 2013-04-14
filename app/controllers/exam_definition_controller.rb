class ExamDefinitionController < ApplicationController
	def new
		@examDefinition = ExamDefinition.new
		@languages = MasterQuestion.select("DISTINCT language")
		@concepts = MasterQuestion.where(language: MasterQuestion.where(id: params[:language]).select("language")).select("DISTINCT concept")
		@subconcepts = MasterQuestion.where(language: MasterQuestion.where(id: params[:language]).select("language")).select("DISTINCT subconcept")
	end

	def create
		@examDefinition = ExamDefinition.new(params[:examID])
		@examDefinition.utype = 0
		
		if @examDefinition.save
			flash[:notice] = "Definición de examen creada de manera exitosa."
		else
			flash[:error] = "Los datos no son válidos."
		end

		redirect_to(root_path)
	end
end
