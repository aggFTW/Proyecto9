GenRap::Application.routes.draw do
  # get "sessions/login,"

  # get "sessions/home,"

  # get "sessions/profile,"

  # get "sessions/setting"

  # The priority is based upon order of creation:
  # first created -> highest priority.

 root :to => 'users#signup'

<<<<<<< HEAD
  resources :users, :groups, :master_questions, :exam_definitions, :exams
=======
  resources :users, :groups, :exam_definitions#, :master_questions
>>>>>>> examDefinition
  
  match "signup", :to => "users#new"
  match "login", :to => "sessions#login"
  match "logout", :to => "sessions#logout"
  match "mq", :to => "master_question#new"
  match "def", to: "exam_definition#new"
<<<<<<< HEAD
  match "exams", to: "exams#index"
  match "pending", to: "exams#pending"
=======
  match "master_questions/languages_for_question" => "master_question#languages_for_question"

  #resources :master_questions, :only => [:show], :defaults => { :format => 'json' }
>>>>>>> examDefinition

end
