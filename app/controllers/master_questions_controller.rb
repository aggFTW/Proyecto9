class MasterQuestionsController < ApplicationController
  @randomizer_path = "/../helpers/r/"
  @solver_path = "/../helpers/s/"

  def new
    @master_question = MasterQuestion.new
  end
  
  def create
    @master_question = MasterQuestion.new(params[:master_question])
    
    time = Time.new
    randomizer_filename = "#{time.year}#{time.month}#{time.day}_#{time.hour}:#{time.min}:#{time.sec}_randomizer"
    solver_filename = "#{time.year}#{time.month}#{time.day}_#{time.hour}:#{time.min}:#{time.sec}_solver"
    
    randomizer_file = File.open(File.dirname(__FILE__) + "/../helpers/r/#{randomizer_filename}","w") {|f| f.write("#{@master_question.randomizer}") }
    solver_file = File.open(File.dirname(__FILE__) + "/../helpers/s/#{solver_filename}","w") {|f| f.write("#{@master_question.solver}")}

    @master_question.randomizer = File.dirname(__FILE__) + "/../helpers/r/#{randomizer_filename}"
    @master_question.solver = File.dirname(__FILE__) + "/../helpers/s/#{solver_filename}"

    if @master_question.save
      flash[:notice] = "MasterQuestion creada exitosamente."
    else
      #flash[:error] = "Los datos proporcionados no son válidos."
    end
    redirect_to(root_path)
  end

  def index
   # if check_prof
      @masterQuestions = MasterQuestion.all
    #else
     # flash[:error] = "Usted necesita ser un administrador para accesar esta página."
     # redirect_to(root_path)
    #end
  end

  def destroy
    #if check_prof
      @master_question = MasterQuestion.find(params[:id])
      @master_question.destroy

      redirect_to :action => 'index'
    #else
      #flash[:error] = "Debe ser administrador para borrar master questions."
     # redirect_to(root_path)
    #end
  end
end
