class Exam < ActiveRecord::Base
  belongs_to :master_exam
  belongs_to :user
  has_many :questions

  validates :state,	:presence => true
  validates :score,	:presence => true,
  					:numericality => { :greater_than_or_equal_to => 0.0,
  										:less_than_or_equal_to => 100.0 }

  attr_accessible :date, :questions_attributes
  accepts_nested_attributes_for :questions



  def self.createInstance(master_exam_id, user_id)
  		# session = Hash.new
  		# session[:user_id] = 9

  		ActiveRecord::Base.transaction do
			exam = Exam.new

			# Create exam
			exam.master_exam = MasterExam.find(master_exam_id)
			exam.user = User.find user_id
			exam.state = "0"
			exam.date = Time.now
			exam.score = 0
			
			user = User.find(user_id)
			
			if exam.master_exam.users.include? user
				attemptN = Exam.where("master_exam_id = ? and user_id = ?", master_exam_id, user_id).size

				if attemptN < exam.master_exam.attempts
					exam.attemptnumber = attemptN + 1

					if exam.save
						# flash[:notice] = "Examen creado de manera exitosa."
						puts "Examen creado de manera exitosa."
					else
						# flash[:error] = "No se pudo crear el examen."
						puts "No se pudo crear el examen."
						raise ActiveRecord::Rollback
					end
				else
					# flash[:error] = "Se han agotado los attempts."
					puts "Se han agotado los attempts."
					raise ActiveRecord::Rollback
				end
			else
				# flash[:error] = "Usuario no puede tomar este examen."
				puts "Usuario no puede tomar este examen."
				raise ActiveRecord::Rollback
			end

			# Create questions
			e_definition = ExamDefinition.where("master_exam_id = ?", master_exam_id)
			for mQuestion in e_definition
				master_question = MasterQuestion.find(mQuestion.master_question_id)
				inquiry = master_question.inquiry

				# We generate random question
				randomizer_path = master_question.randomizer
				full_randomizer_path = File.dirname(__FILE__) + "/.." + randomizer_path
				# full_randomizer_path = File.dirname(__FILE__) + "/../helpers/r/" + randomizer_path + '.rb'
				load full_randomizer_path
				puts "loaded " + full_randomizer_path
				values = randomize(inquiry)
				# puts "values " + values.to_s

				# We generate values, correctAns
				solver_path = master_question.solver
				full_solver_path = File.dirname(__FILE__) + "/.." + solver_path
				# full_solver_path = File.dirname(__FILE__) + "/../helpers/s/" + solver_path + '.rb'
				load full_solver_path
				puts "loaded " + full_solver_path
				answers, correctAns = solve(inquiry, values)
				# puts "answers " + answers.to_s
				# puts "correctAns " + correctAns.to_s

				# We finally create the question
				question = Question.new
				# puts "exam " + exam.to_s
				question.exam = exam
				question.master_question = master_question
				question.questionNum = mQuestion.questionNum
				question.values = values
				question.answers = answers
				question.correctAns = correctAns
				question.givenAns = ""

				if question.save
					# flash[:notice] = "Pregunta creada de manera exitosa."
					puts "Pregunta creada de manera exitosa."
				else
					# flash[:error] = "No se pudo crear la pregunta."
					puts "No se pudo crear la pregunta."
					raise ActiveRecord::Rollback
				end
			end #end for

			#Return exam
			exam

		end  #end transaction
	end #end method

end
