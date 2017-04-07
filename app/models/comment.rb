class Comment < ApplicationRecord

  enum state: [:created, :verified, :locked]

  belongs_to :post
  belongs_to :user

  validates :body, presence: true

  scope :ordered, ->{ order created_at: :desc }
  scope :for_user, -> { where state: :verified }
  scope :for_admin, -> { all }
  scope :for_moderator, -> { all }

end
