class MasterQuestionController < ApplicationController
  def new
    @master_question = MasterQuestion.new
  end
  
  def create
    @master_question = MasterQuestion.new(params[:master_question])
    
    if @master_question.save
      flash[:notice] = "MasterQuestion creada exitosamente."
    else
      flash[:error] = "Los datos proporcionados no son válidos."
    end

    redirect_to(root_path)
  end
end
