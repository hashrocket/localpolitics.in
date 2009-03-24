ActionController::Routing::Routes.draw do |map|
  map.congress_person 'congress_people/:id', :controller => 'congress_people', :action => 'show'
  map.twitter_invite  'congress_people/:id/twitter_invite', :controller => 'congress_people', :action => 'twitter_invite'
  map.send_twitter_invite  'congress_people/:id/send_twitter_invite', :conditions => { :method => :post }, :controller => 'congress_people', :action => 'send_twitter_invite'
  map.zip ':f_address', :controller => 'localities', :action => 'show'
  map.root :controller => 'localities', :action => 'index'
end

