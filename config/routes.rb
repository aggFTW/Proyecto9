GenRap::Application.routes.draw do
  # get "sessions/login,"

  # get "sessions/home,"

  # get "sessions/profile,"

  # get "sessions/setting"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  root :to => 'users#signup'

  resources :users, :groups, :master_questions, :exam_definitions, :exams, :master_exams
  
  match "signup", :to => "users#new"
  match "login", :to => "sessions#login"
  match "logout", :to => "sessions#logout"
  match "mq", :to => "master_question#new"
  match "def", to: "exam_definition#new"
  match "exams", to: "exams#index"
  match "pending", to: "exams#pending"

end
