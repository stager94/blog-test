class Post < ApplicationRecord
  belongs_to :user
  has_many :comments

  has_attached_file :cover, styles: {
    medium: ["620x250>", :png]
  }
  validates_attachment_content_type :cover, content_type: /\Aimage\/.*\z/

  validates :body, presence: true, length: { minimum: 100 }
  validates :title, presence: true
  validates :cover, presence: true

  scope :published, ->{ where is_published: true }
end
