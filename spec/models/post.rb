require 'rails_helper'

describe Post do

  it { should validate_presence_of :body }
  it { should validate_length_of(:body).is_at_least(100) }
  it { should validate_presence_of :title }
  it { should validate_presence_of :cover }

end
