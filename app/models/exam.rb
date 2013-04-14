class Exam < ActiveRecord::Base
  belongs_to :master_exam
  belongs_to :user
  has_many :questions

  validates :state,	:presence => true
  validates :score,	:presence => true,
  					:numericality => { :greater_than_or_equal_to => 0.0,
  										:less_than_or_equal_to => 100.0 }

  attr_accessible :date



  def self.createInstance(master_exam_id)
  		ActiveRecord::Base.transaction do
			exam = Exam.new

			# Create exam
			exam.master_exam = MasterExam.find(master_exam_id)
			exam.user = User.find session[:user_id]
			# exam.user = User.find(9)
			exam.state = "0"
			exam.date = Time.now
			exam.score = 0
			
			user = User.find(session[:user_id])
			# user = User.find(9)
			if exam.master_exam.users.include? user
				if Exam.where("master_exam_id = ? and user_id = ?", master_exam_id, session[:user_id]).empty?
				# if Exam.where("master_exam_id = ? and user_id = ?", master_exam_id, 9).empty?
					if exam.save
						# flash[:notice] = "Examen creado de manera exitosa."
						puts "Examen creado de manera exitosa."
					else
						# flash[:error] = "No se pudo crear el examen."
						puts "No se pudo crear el examen."
						raise ActiveRecord::Rollback
						# return
					end
				else
					# flash[:error] = "Examen ya habia sido creado."
					puts "Examen ya habia sido creado."
					exam = Exam.where("master_exam_id = ? and user_id = ?", master_exam_id, session[:user_id]).first
					# exam = Exam.where("master_exam_id = ? and user_id = ?", master_exam_id, 9).first
				end
			else
				# flash[:error] = "Usuario no puede tomar este examen."
				puts "Usuario no puede tomar este examen."
				raise ActiveRecord::Rollback
				# return
			end

			# Create questions
			e_definition = ExamDefinition.where("master_exam_id = ?", master_exam_id)
			for mQuestion in e_definition
				master_question = MasterQuestion.find(mQuestion.master_question_id)
				inquiry = master_question.inquiry

				# We generate random question
				randomizer_path = master_question.randomizer
				full_randomizer_path = File.dirname(__FILE__) + "/../helpers/r/" + randomizer_path + ".rb"
				load full_randomizer_path
				puts "loaded " + full_randomizer_path
				values = randomize(inquiry)
				# puts "values " + values.to_s

				# We generate values, correctAns
				solver_path = master_question.solver
				full_solver_path = File.dirname(__FILE__) + "/../helpers/s/" + solver_path + ".rb"
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

				# puts question.exam
				# puts question.master_question
				# puts question.questionNum
				# puts question.values
				# puts question.answers
				# puts question.correctAns
				# puts question.givenAns

				if question.save
					# flash[:notice] = "Pregunta creada de manera exitosa."
					puts "Pregunta creada de manera exitosa."
				else
					# flash[:error] = "No se pudo crear la pregunta."
					puts "No se pudo crear la pregunta."
					raise ActiveRecord::Rollback
					# return
				end
			end #end for

		end  #end transaction
	end #end method

end
