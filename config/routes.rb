Rails.application.routes.draw do
  get 'quiz/start', to: 'quiz#start'
  get 'quiz/result', to: 'quiz#result'
  get 'home/index'
  root "home#index"
end
