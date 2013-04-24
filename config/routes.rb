GenRap::Application.routes.draw do
  # get "sessions/login,"

  # get "sessions/home,"

  # get "sessions/profile,"

  # get "sessions/setting"

  # The priority is based upon order of creation:
  # first created -> highest priority.

 root :to => 'users#signup'


  resources :users, :groups, :master_questions, :exam_definitions, :exams
  
  match "signup", :to => "users#new"
  match "login", :to => "sessions#login"
  match "logout", :to => "sessions#logout"
  match "mq", :to => "master_question#new"
  match "def", to: "exam_definition#new"
  match "exams", to: "exams#index"
  match "create/exam/:id", to: "exams#create", as: "create_exam"
  match "pending", to: "exams#pending"

  #json stuff for exam definition
  match "master_question/concepts_for_question" => "master_questions#concepts_for_question"
  match "master_question/subconcepts_for_question" => "master_questions#subconcepts_for_question"
  match "master_question/filtered_master_questions" => "master_questions#filtered_master_questions"
  match "master_question/transmiting_JSON" => "master_questions#transmiting_JSON"

  #resources :master_questions, :only => [:show], :defaults => { :format => 'json' }

end
