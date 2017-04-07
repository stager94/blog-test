require 'rails_helper'

describe Tagging do

  it { should belong_to(:post) }
  it { should belong_to(:tag) }

end
