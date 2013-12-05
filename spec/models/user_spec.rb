require 'spec_helper'
require 'ostruct'

describe User do
  describe "using AT&T auth" do
    let(:auth) do
      OpenStruct.new(
        uid: 'att-abcd1234',
        provider: 'att',
        credentials: OpenStruct.new(token: 'zyxwvut4321'),
        info: OpenStruct.new(
          first_name: 'Test',
          last_name: 'User',
          email: 'test@example.com',
          phone_number: '14045551234'
        )
      )
    end

    it %q{should find a user who has previously logged in via AT&T} do
      user = FactoryGirl.build(:user)
      user.uid = auth.uid
      user.provider = auth.provider
      user.save!
      User.find_or_create_from_auth_hash(auth).should == user
    end

    it %q{should create a new user when no previous AT&T login and no matching email address} do
      found_user = User.find_or_create_from_auth_hash(auth)
      found_user.first_name.should == 'Test'
      found_user.last_name.should == 'User'
      found_user.email.should == 'test@example.com'
      found_user.persisted?.should be true
    end

  end

  describe '#admin' do
    it "should not be possible to mass assign :admin" do
      user = FactoryGirl.build(:user)
      expect { user.update_attributes({admin: true}) }.to raise_error
    end

    it %q{should disable admin_mode when removing admin bit} do
      user = FactoryGirl.build :user
      user.admin = true
      user.admin_mode = true
      user.save!

      user.reload
      user.admin.should be true
      user.admin_mode.should be true
      user.admin = false

      user.save!
      user.reload
      user.admin_mode.should be false
    end
  end
end
