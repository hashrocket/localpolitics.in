ActionController::Routing::Routes.draw do |map|
  map.zip 'zip/:q', :controller => 'localities', :action => 'show'
  map.root :controller => 'localities', :action => 'index'
end

