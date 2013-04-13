class MasterQuestionsController < ApplicationController
  @randomizer_path = "/"
  @solver_path = "/"

  def new
    @master_question = MasterQuestion.new
  end
  
  def create
    @master_question = MasterQuestion.new(params[:master_question])
    
    time = Time.new
    randomizer_filename = "#{time.year}#{time.month}#{time.day}_#{time.hour}:#{time.min}:#{time.sec}_randomizer"
    solver_filename = "#{time.year}#{time.month}#{time.day}_#{time.hour}:#{time.min}:#{time.sec}_solver"
    
    randomizer_file = File.open(randomizer_filename,"w") {|f| f.write("#{@master_question.randomizer}") }
    solver_file = File.open(solver_filename,"w") {|f| f.write("#{@master_question.solver}")}

    @master_question.randomizer = "#{@randomizer_path}#{randomizer_filename}"
    @master_question.solver = "#{@solver_path}#{solver_filename}"

    if @master_question.save
      flash[:notice] = "MasterQuestion creada exitosamente."
    else
      #flash[:error] = "Los datos proporcionados no son válidos."
    end
    redirect_to(root_path)
  end

  def index
    #if check_admin
      @masterQuestions = MasterQuestion.all
    #else
     # flash[:error] = "Usted necesita ser un administrador para accesar esta página."
      #redirect_to(root_path)
    #end
  end
end
