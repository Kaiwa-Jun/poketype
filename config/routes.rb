# frozen_string_literal: true

Rails.application.routes.draw do
  get 'quiz/result', to: 'quiz#result'
  get 'quiz/new', to: 'quiz#new'
  get 'home/index'
  root 'quiz#new'
  get 'quiz/start', to: 'quiz#start', as: 'quiz_start'
  get 'quiz/restart', to: 'quiz#restart', as: 'quiz_restart'
  post 'quiz/confirm', to: 'quiz#confirm'
end
