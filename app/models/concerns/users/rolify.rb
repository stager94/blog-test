module Users
  module Rolify

    extend ActiveSupport::Concern

    included do
      enum role: [:user, :moderator, :admin]
    end

  end
end
