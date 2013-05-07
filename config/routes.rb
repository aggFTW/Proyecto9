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
  # match "mq", :to => "master_question#new"
  match "def", to: "exam_definition#new"
  match "exams", to: "exams#index"
  match "create/exam/:id", to: "exams#create", as: "create_exam"
  match "pending", to: "exams#pending"
  match "edit/:id", to: "exam_definition#edit"
  match "mystats", to: "stats#mystats"
  match "profstats", to: "stats#profstats"

  #json stuff for exam definition
  # match "exam_definition/exam_def" => "exam_definitions#exam_def"
  match "master_question/concepts_for_question" => "master_questions#concepts_for_question"
  match "master_question/subconcepts_for_question" => "master_questions#subconcepts_for_question"
  match "master_question/filtered_master_questions" => "master_questions#filtered_master_questions"
  match "master_question/transmiting_JSON" => "master_questions#transmiting_JSON"
  match "master_question/exam_def" => "master_questions#exam_def"
  match "master_question/transmit_UserId" => "master_questions#transmit_UserId"

  match "exam_definition/get_exams" => "exam_definition#get_exams"
  match "exam_definition/get_groups" => "exam_definition#get_groups"
  match "exam_definition/get_users" => "exam_definition#get_users"
  match "exam_definition/get_current_user" => "exam_definition#get_current_user"

  #resources :master_questions, :only => [:show], :defaults => { :format => 'json' }

  # map.exam_show, '/exams/:id', :controller => :exams, :action => :show

end
