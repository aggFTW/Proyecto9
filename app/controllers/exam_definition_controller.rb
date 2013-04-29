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
	end

	def update
	end

	def destroy
	end

	def index
	end

	#require 'json'
	#require 'open-uri'

	def exam_def 
		# @dummy = Array.new
		# @dummy.push params[:hash]
	 #    respond_to do |format|
	 #      format.json { render json: @dummy.to_json }
	 #  	end
		# #json = open("/examDef/1").read
		# #puts json
		# #decoded_json = ActiveSupport::JSON.decode json
		# #redirect_to '/def'
	end
end