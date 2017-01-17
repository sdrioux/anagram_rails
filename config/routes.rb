Rails.application.routes.draw do
  post   '/words',          to: 'words#create'
  delete '/words/:word',    to: 'words#destroy'
  delete '/words',          to: 'words#destroy_all'

  get    '/words/:word/anagrams', to: 'words#show'
  get    '/anagrams/:word', to: 'words#show'
end
