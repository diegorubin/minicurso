Snippets::Application.routes.draw do
  
  resources :snippets

  root :to => "snippets#index"
end
