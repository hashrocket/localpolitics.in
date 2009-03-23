require 'culerity'
require 'spec/spec_helper'

Before do
  $server ||= Culerity::run_server
  $browser = Culerity::RemoteBrowserProxy.new $server, {:browser => :firefox}
  $browser.close
  @host = 'http://localhost:3001'
end

at_exit do
  $browser.exit
  $server.close
end

Given "I stub out all api calls" do
  stub_out_open_secrets_new
  @campaign_finance = stub_nytimes_finance
end

Given "I Google" do
  $browser.goto('http://www.google.com')
end

Given "I am home" do
  $browser.goto(@host)
end

Given "I raise the response" do
  raise $browser.html.inspect
end

Then /^I should see a link named "(.*)"$/ do |text|
    $browser.html.should have_tag('a', text)
end

Then /I should see "(.*)"/ do |text|
    $browser.text.gsub(/\s+/,' ').should include_text(text.gsub(/\s+/,' '))
end

Then /^I should be on the (.+) page$/ do |page_name|
    $browser.url.should == @host + path_to(page_name)
end

Then /^I should see a "(.*)" text field$/ do |name|
  $browser.text_field(:id, find_label(name).for)#.set(value)
end

Then /^I should see a "(.*)" dropbox$/ do |name|
    $browser.html.should have_tag('select[name=?]', name)
end

Then /^the "(.*)" element should be displayed$/ do |name|
  # $browser.div(:id, name).should be_visible
  $browser.element_by_xpath("//*[@id='#{name}']").should be_visible
end

When /I fill in "(.*)" for "(.*)"/ do |value, field|
  $browser.text_field(:id, find_label(field).for).set(value)
end

When /^I submit the (.*) form$/ do |form_id|
  $browser.form(:id => form_id).submit
end

When /I press "(.*)" with javascript enabled/ do |button|
  $browser.button(:text, button).click
  assert_successful_response
end

# 
# When /I follow "(.*)"/ do |link|
#   $browser.link(:text, /#{link}/).click
#   assert_successful_response
# end
# 
# When /I check "(.*)"/ do |field|
#   $browser.check_box(:id, find_label(field).for).set(true)
# end
# 
# When /^I uncheck "(.*)"$/ do |field|
#   $browser.check_box(:id, find_label(field).for).set(false)
# end
# 
# When /I choose "(.*)"/ do |field|
#   $browser.radio(:id, find_label(field).for).set(true)
# end
# 
# When /I go to (.+)/ do |path|
#   $browser.goto @host + path_to(path)
# end
# 
# When "I wait for the AJAX call to finish" do
#   #$browser.page.getEnclosingWindow().getThreadManager().joinAll(10000)
#   $browser.wait
# end
# 
# 
# Then /I should see "(.*)"/ do |text|
#   $browser.html.should  =~ /#{text}/m
# end
# 
# Then /I should not see "(.*)"/ do |text|
#   $browser.html.should_not  =~ /#{text}/m
# end

def find_label(text)
  $browser.label :text, text
end

def assert_successful_response
  status = $browser.page.web_response.status_code
  if(status == 302 || status == 301)
    location = $browser.page.web_response.get_response_header_value('Location')
    puts "Being redirected to #{location}"
    $browser.goto location
  elsif status != 200
    raise "Brower returned Response Code #{$browser.page.web_response.status_code}"
  end
end
