#encoding: utf-8
class StatsController < ApplicationController

	before_filter :authenticate_user, :only[:mystats, :profstats]

	def mystats
		@exams_taken = @current_user.exams

		@q_taken = @exams_taken.map { |e| e.questions }
		@q_taken = @q_taken.flatten

		q_info = @q_taken.map { |q| [MasterQuestion.find(q.master_question_id).language.capitalize, MasterQuestion.find(q.master_question_id).concept.capitalize, MasterQuestion.find(q.master_question_id).subconcept.capitalize, right_answer?(q)] }

		@q_taken_by_language = {}
		for quad in q_info
			if @q_taken_by_language.has_key? quad[0]
				if @q_taken_by_language[quad[0]].has_key? quad[1]
					if @q_taken_by_language[quad[0]][quad[1]].has_key? quad[2]
						@q_taken_by_language[quad[0]][quad[1]][quad[2]] << quad[3]
					else
						@q_taken_by_language[quad[0]][quad[1]][quad[2]] = [quad[3]]
					end
				else
					@q_taken_by_language[quad[0]][quad[1]] = { quad[2] => [quad[3]] }
				end
			else
				@q_taken_by_language[quad[0]] = { quad[1] => { quad[2] => [quad[3]] } }
			end
		end
	end

	# Returns 1 if question was answered correctly, 0 otherwise
	private
		def right_answer? (q)
			if q.correctAns == q. givenAns
				return 1
			else 
				return 0
			end
		end

	def profstats
		if check_prof

			@exams_agg = {}
			for e in MasterExam.where("user_id = ?", @current_user.id)
				actualExams = e.exams
				average = 0
				for a in actualExams
					average += a.score
				end
				if actualExams.length > 0
					average /= actualExams.length
				end

				@exams_agg[e] = [average, actualExams.length, e.users.length]
			end

			# Information returned is about questions from all professors, in aggregate
			# not only from exams by professor
			@questions_agg = {}
			for e in MasterExam.where("user_id = ?", @current_user.id)
				for q in e.master_questions
					actualQuestions = q.questions
					
					right = actualQuestions.map { |a| right_answer? a }
					right = right.inject{|sum,x| sum + x }

					if @questions_agg.has_key? q
						@questions_agg[q][0] += right
						@questions_agg[q][1] += (actualQuestions.length - right)
					else
						@questions_agg[q] = [right, actualQuestions.length - right]
					end
				end
			end

		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

end
