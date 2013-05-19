
GenRap::Application.routes.draw do
  # get "sessions/login,"

  # get "sessions/home,"

  # get "sessions/profile,"

  # get "sessions/setting"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  root :to => 'exams#pending'


  resources :users, :groups, :master_questions, :exam_definitions, :exams
  
  match "signup", :to => "users#new"
  match "login", :to => "sessions#login"
  match "logout", :to => "sessions#logout"
  # match "mq", :to => "master_question#new"
  match "def", to: "exam_definition#new"
  match "results/exam/:id", to: "exams#results", as: "exam_results"
  match "create/exam/:id", to: "exams#create", as: "create_exam"
  match "pending", to: "exams#pending"
  match "edit/:id", to: "exam_definition#edit"
  match "mystats", to: "stats#mystats"
  match "profstats", to: "stats#profstats"

  #json routes in MasterQuestion controller
  match "master_question/concepts_for_question" => "master_questions#concepts_for_question"
  match "master_question/subconcepts_for_question" => "master_questions#subconcepts_for_question"
  match "master_question/filtered_master_questions" => "master_questions#filtered_master_questions"
  match "master_question/transmiting_JSON" => "master_questions#transmiting_JSON"
  match "master_question/get_languages" => "master_questions#get_languages"

  #json routes in Exams controller
  match "exam/get_exams" => "exams#get_exams"

  #json routes in Groups controller 
  match "group/get_groups" => "groups#get_groups"

  #json routes in Users controller
  match "user/get_users" => "users#get_users"
  match "user/get_current_user" => "users#get_current_user"
  match "user/set_users_cantake" => "users#set_users_cantake"
  match "user/set_user_cantake_own" => "users#set_user_cantake_own"

  # map.exam_show, '/exams/:id', :controller => :exams, :action => :show

end

