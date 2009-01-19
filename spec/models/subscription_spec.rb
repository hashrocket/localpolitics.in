require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Subscription do
  before do
    @user = User.new
    @user.subscriptions.stubs(:find_by_location_data)
    @user.subscriptions.stubs(:create)
  end

  it "should add location to user with no subscriptions" do
    @user.subscriptions.expects(:find_by_location_data).with('32250')
    @user.subscriptions.expects(:create).with(:location_data => '32250')
    Subscription.add_location_to_user("32250", @user)
  end

  it "should not add a duplicate location subscription to a user"

  it "should parse the location data" do
    subscription = Subscription.new
    @user.subscriptions.expects(:create).with(:location_data => '32250').returns(subscription)
    subscription.expects(:parse_location_data!)
    Subscription.add_location_to_user("32250", @user)
  end
end

