module Posts
  module Taggable

    extend ActiveSupport::Concern

    included do

      has_many :taggings, dependent: :destroy
      has_many :tags, through: :taggings

      def tags_list=(names)
        self.tags = names.split(",").map do |name|
            Tag.where(name: name.strip).first_or_create!
        end
      end

      def tags_list
        self.tags.map(&:name).join(", ")
      end

    end

  end
end
