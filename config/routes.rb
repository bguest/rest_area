RestArea::Engine.routes.draw do
  get '/:klass', :to => "rest#index"
  get '/:klass/:id', :to => "rest#show"
  get '/:klass/:id/:message', :to => 'message#get'
  post '/:klass', :to => "rest#create"
  put '/:klass/:id', :to => "rest#update"
  delete '/:klass/:id', :to => "rest#delete"
end
