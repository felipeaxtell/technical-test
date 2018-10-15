Rails.application.routes.draw do
  root 'areas#index'
  
  defaults format: :json do
    resources :areas
    post 'generate_xlsx' => 'areas#generate_xlsx'
  end
end
