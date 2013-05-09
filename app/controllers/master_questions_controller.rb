#encoding: utf-8
class MasterQuestionsController < ApplicationController
  $randomizer = ''
  $solver = ''
  @inquiriesMasterQuestionsIDs = {}

  before_filter :authenticate_user, :only => [:new, :index, :create,:show, :edit, :update, :destroy]
  # Create actions
  def new
    if check_admin || check_prof
      @master_question = MasterQuestion.new
      @master_question.randomizer = initialize_file('randomizer')
      @master_question.solver = initialize_file('solver')
    else
      flash[:error] = "Los datos proporcionados no son válidos."
      redirect_to(root_path)
    end
  end
  
  def create
    @master_question = MasterQuestion.new(params[:master_question])
    
    # Generate random name for solver and randomizer
    uuid = SecureRandom.uuid
    $randomizer = "#{uuid}_randomizer"
    $solver = "#{uuid}_solver"
    
    # Create solver and randomizer files in /helpers/s and /helpers/r 
    randomizer_file = File.open(File.dirname(__FILE__) + "/../helpers/r/#{$randomizer}.rb","w") {|f| f.write("#{@master_question.randomizer}") }
    solver_file = File.open(File.dirname(__FILE__) + "/../helpers/s/#{$solver}.rb","w") {|f| f.write("#{@master_question.solver}")}

    # Save masterquestion solver and randomizer file path
    @master_question.randomizer = "#{$randomizer}"
    @master_question.solver = "#{$solver}"

    if @master_question.save
      flash[:notice] = "MasterQuestion creada exitosamente."
    else
      flash[:error] = "Los datos proporcionados no son válidos."
    end
    redirect_to(master_questions_path)
  end

  # Read actions
  def index
    if check_prof || check_admin
      @masterQuestions = MasterQuestion.all
    else
      flash[:error] = "Usted necesita ser un administrador para accesar esta página."
      redirect_to(root_path)
    end
  end

  def show
    if check_prof || check_admin
      @master_question = MasterQuestion.find(params[:id])

      # Get files path
      $randomizer = @master_question.randomizer
      $solver = @master_question.solver 

      # Retrieve code from files
      @master_question.randomizer = read_file(File.dirname(__FILE__) + "/../helpers/r/#{$randomizer}.rb")
      @master_question.solver = read_file(File.dirname(__FILE__) + "/../helpers/s/#{$solver}.rb")
    else
      flash[:error] = "Usted necesita ser un administrador para accesar esta página."
      redirect_to(root_path)
    end
  end

  #Update actions
  def edit
    if check_prof || check_admin
      @master_question = MasterQuestion.find(params[:id])
      
      $randomizer = @master_question.randomizer
      $solver = @master_question.solver 

      # Retrieve code from files
      @master_question.randomizer = read_file(File.dirname(__FILE__) + "/../helpers/r/#{$randomizer}.rb")
      @master_question.solver = read_file(File.dirname(__FILE__) + "/../helpers/s/#{$solver}.rb")
    else
      flash[:error] = "Usted necesita ser un administrador para accesar esta página."
      redirect_to(root_path)
    end
  end

  def update
    if check_prof || check_admin
      @master_question = MasterQuestion.find(params[:id])

      # Create master temporal
      master_temporal =  MasterQuestion.new(params[:master_question])

      # Saves code to randomizer and solver files
      File.open(File.dirname(__FILE__) + "/../helpers/r/#{$randomizer}.rb","w") {|f| f.write("#{master_temporal.randomizer}")}
      File.open(File.dirname(__FILE__) + "/../helpers/s/#{$solver}.rb","w") {|f| f.write("#{master_temporal.solver}")}

      # Updates randomizer and solver fields
      master_temporal.randomizer = $randomizer
      master_temporal.solver = $solver

      if @master_question.update_attributes(:language => master_temporal.language, :concept => master_temporal.concept, :subconcept => master_temporal.subconcept,
                                         :inquiry => master_temporal.inquiry, :randomizer => master_temporal.randomizer, :solver => master_temporal.solver)
        flash[:notice] = 'La pregunta maestra fue actualizada de manera correcta.'
      else
        flash[:error] = 'No se pudieron actualizar los datos de la pregunta maestra.'
      end

      redirect_to(@master_question)
    else
     flash[:error] = "Usted necesita ser un administrador para accesar esta página."
     redirect_to(root_path)
    end
  end

  # Read file from file_path

  def read_file (file_path)
    @code = ''
    File.open(file_path,'r') do |file|
      while line = file.gets
        @code << line
      end
    end
    @code
  end

  # Write initialize file
  def initialize_file filename
    text = ''
    case filename
    when 'randomizer'
      text << "def randomize(inquiry)\n  values = Hash.new('')\n" +
              "  #Inserte su codigo para llenar values aqui\n" +
              "  #values['^1'] = 2\n  #values['^2'] = 2\n" + 
              "  values\nend"
    when 'solver'
      text << "def solve(inquiry, values)\n  answers = Hash.new('')\n" +
              "  #Inserte su codigo para llenar generar answers aqui\n" +
              "  #answers[1] = 2\n  #answers[2] = 3\n" +
              "  #Inserte su codigo para indicar la respuesta correcta\n" +
              "  #correct = 1\n  [answers, correct]\nend"
    end
    text
  end

  # Delete actions
  def destroy
    if check_prof || check_admin
      @master_question = MasterQuestion.find(params[:id])
      
      # Delete randomizer and solver files
      if File.exists?(@master_question.randomizer)
        File.delete(@master_question.randomizer)
      end

      if File.exists?(@master_question.solver)
        File.delete(@master_question.solver)
      end

      @master_question.destroy

      redirect_to :action => 'index'
    else
      flash[:error] = "Debe ser administrador para borrar master questions."
      redirect_to(master_questions_path)
    end
  end

  def concepts_for_question
    concepts = MasterQuestion.select("DISTINCT(concept), id").group("concept").where(language: params[:language])
    respond_to do |format|
      format.json { render json: concepts.to_json }
    end
  end

  def subconcepts_for_question
    subconcepts = MasterQuestion.select("DISTINCT(subconcept), id").group("subconcept").where(language: params[:language], concept: params[:concept])
    respond_to do |format|
      format.json { render json: subconcepts.to_json }
    end
  end

  def filtered_master_questions
    filteredMQs = MasterQuestion.select("inquiry, id").where(language: params[:language], concept: params[:concept], subconcept: params[:subconcept])
    respond_to do |format|
      format.json { render json: filteredMQs.to_json }
    end
  end

  def transmiting_JSON
    @inquiriesMasterQuestionsIDs = Array.new
    @inquiriesMasterQuestionsIDs.push params[:masterQuestionID]
    respond_to do |format|
      format.json { render json: @inquiriesMasterQuestionsIDs.to_json }
    end
  end
end
