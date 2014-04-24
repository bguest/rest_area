Rails.application.routes.draw do
  mount RestArea::Engine => "/rest"
end
