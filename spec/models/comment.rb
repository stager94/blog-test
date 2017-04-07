require 'rails_helper'

describe Comment do

  it { should validate_presence_of :body }
  it { should define_enum_for(:state) }

  it { should belong_to(:post) }
  it { should belong_to(:user) }


end
