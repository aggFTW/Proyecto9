class MasterQuestionController < ApplicationController

	def languages_for_question
		master_questions = MasterQuestion.find_by_language(params[:language])
		respond_to do |format|
			format.json { render :json => master_questions.to_json }
		end
	end


end