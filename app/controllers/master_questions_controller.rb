#encoding: utf-8
class MasterQuestionsController < ApplicationController
  $randomizer = ''
  $solver = ''
  @inquiriesMasterQuestionsIDs = {}

  before_filter :authenticate_user, :only => [:new, :index, :create,:show, :edit, :update, :destroy]
  # Create actions
  def new
    if check_admin || check_prof
      if @master_question == nil
        @master_question = MasterQuestion.new
        @master_question.randomizer = initialize_file('randomizer')
        @master_question.solver = initialize_file('solver')
        @master_question.inquiry = initialize_file('inquiry')
      else
        @master_question = params[:object]
      end
    else
      flash[:error] = "Acceso restringido."
      redirect_to(root_path)
    end
  end
  
  def create
    if check_prof || check_admin
      @master_question = MasterQuestion.new(params[:master_question])
      
      # Generate random name for solver and randomizer
      uuid = SecureRandom.uuid
      $randomizer = "#{uuid}_randomizer"
      $solver = "#{uuid}_solver"
      
      # Create solver and randomizer files in /helpers/s and /helpers/r 
      rand_file = File.dirname(__FILE__) + "/../helpers/r/#{$randomizer}.rb"
      solv_file = File.dirname(__FILE__) + "/../helpers/s/#{$solver}.rb"

      randomizer_file = File.open(rand_file,"w") {|f| f.write("#{@master_question.randomizer}") }
      solver_file = File.open(solv_file,"w") {|f| f.write("#{@master_question.solver}")}

      rand_file_error = false
      solv_file_error = false


      # Verficicar error en el randomizer
      begin
        load rand_file
      rescue Exception => exc
        rand_file_error = true
      end

      # Verificar error en el solver
      begin
        load solv_file
      rescue Exception => exc
        solv_file_error = true
      end

      # Notificar del error
      if solv_file_error && rand_file_error
        flash[:error] = "Error al ejecutar randomizer y solver, por favor revise su código."
        render :action => "new" and return
      elsif solv_file_error
        flash[:error] = "Error al ejecutar solver, por favor revise su código."
        render :action => "new" and return
      elsif rand_file_error
        flash[:error] = "Error al ejecutar randomizer, por favor revise su código."
        render :action => "new" and return
      end


      # Save masterquestion solver and randomizer file path
      @master_question.randomizer = "#{$randomizer}"
      @master_question.solver = "#{$solver}"

      if @master_question.save
        flash[:notice] = "MasterQuestion creada exitosamente."
      else
        flash[:error] = "Los datos proporcionados no son válidos."
      end
      redirect_to(master_questions_path)
    else
      flash[:error] = "Acceso restringido."
      redirect_to root_path
    end
  end

  # Read actions
  def index
    if check_prof || check_admin
      @masterQuestions = MasterQuestion.all
    else
      flash[:error] = "Acceso restringido."
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
      flash[:error] = "Acceso restringido."
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
      flash[:error] = "Acceso restringido."
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
      flash[:error] = "Acceso restringido."
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
    when 'inquiry'
      text << "¿Cuánto es ^1 + ^2?"
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
      flash[:error] = "Acceso restringido."
      redirect_to(master_questions_path)
    end
  end

  def concepts_for_question
    concepts = MasterQuestion.select("DISTINCT(concept), id").group("upper(concept)").where("upper(language) = upper('#{params[:language]}')")
    respond_to do |format|
      format.json { render json: concepts.to_json }
    end
  end

  def subconcepts_for_question
    subconcepts = MasterQuestion.select("DISTINCT(subconcept), id").group("upper(subconcept)").where("upper(language) = upper('#{params[:language]}')").where("upper(concept) = upper('#{params[:concept]}')")
    respond_to do |format|
      format.json { render json: subconcepts.to_json }
    end
  end

  def filtered_master_questions
    filteredMQs = MasterQuestion.select("inquiry, id").where("upper(language) = upper('#{params[:language]}')").where("upper(concept) = upper('#{params[:concept]}')").where("upper(subconcept) = upper('#{params[:subconcept]}')")
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

  def get_languages
    languages = MasterQuestion.select("DISTINCT(language), id").group("upper(language)")
    respond_to do |format|
      format.json { render json: languages.to_json }
    end
  end
end
