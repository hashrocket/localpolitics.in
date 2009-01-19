require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  before do
    @user = User.new :email => "user@example.com"
  end

  it "should create a user with a subscription" do
    User.expects(:find_or_create_by_email).with(@user.email).returns(@user)
    Subscription.expects(:add_location_to_user).with("32250", @user)
    User.from_location_and_email("32250",@user.email)
  end

end
