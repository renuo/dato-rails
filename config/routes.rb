Dato::Engine.routes.draw do
  post "live", to: "live#create"
  post "publish", to: "publish#create"
end
