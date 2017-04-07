require 'rails_helper'

describe User do

  it { should validate_presence_of :email }
  it { should validate_uniqueness_of :email }
  it { should validate_presence_of :password }
  it { should validate_length_of(:password).is_at_least(6).on(:create) }


  describe "Authorization" do
    context "on a new user" do
      it "should not be valid without a password" do
        user = User.new password: nil, password_confirmation: nil, email: "test@example.com"
        user.should_not be_valid
      end

      it "should not be valid with a short password" do
        user = User.new password: 'short', password_confirmation: 'short', email: "test@example.com"
        user.should_not be_valid
      end

      it "should not be valid with a confirmation mismatch" do
        user = User.new password: 'short', password_confirmation: 'long', email: "test@example.com"
        user.should_not be_valid
      end
    end

    context "on an existing user" do
      let!(:user) { User.create password: 'password', password_confirmation: 'password', email: "test@example.com" }

      it "should be valid with no changes" do
        user.should be_valid
      end

      it "should not be valid with an empty password" do
        user.password = user.password_confirmation = ""
        user.should_not be_valid
      end

      it "should be valid with a new (valid) password" do
        user.password = user.password_confirmation = "new password"
        user.should be_valid
      end
    end
  end
end
