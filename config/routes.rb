# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

resources :client_report, only: [:create, :show] do
  collection do
    post 'upload', to: 'client_report#upload'
  end

  member do
    get 'download', to: 'client_report#download'
    get 'thank_you', to: 'client_report#thank_you'
  end
end

resources :brief, only: [:create, :index] do
  collection do
    get 'check_project'
    get 'thank_you'
  end
end

