class MasterQuestionController < ApplicationController

	def languages_for_question
		master_questions = MasterQuestion.select("DISTINCT concept").find_all_by_language(params[:language])
		respond_to do |format|
			format.json { render json: master_questions }
		end
	end

	#def print_and_flush(str)
	#  	print str
	#  	$stdout.flush
	#end


end