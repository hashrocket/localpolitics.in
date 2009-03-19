ActionController::Routing::Routes.draw do |map|
  map.congress_person 'congress_people/:id', :controller => 'congress_people', :action => 'show'
  map.zip ':q', :controller => 'localities', :action => 'show'
  map.root :controller => 'localities', :action => 'index'
end

