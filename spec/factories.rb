require 'digest/sha1'

FactoryGirl.define do
  sequence(:email) { |n| "user#{n}@mail.com" }
  sequence(:title) { |n| "Post ##{n}" }

  factory :user do
    email
    password { |n| Digest::SHA1.hexdigest n.to_s }

    factory :user_with_posts do
      posts { Array.new(10) { build(:post) } }
    end

    role "user"
  end

  factory :post do
    title
    cover { File.new("#{Rails.root}/spec/photos/cover.png") }
    body { Faker::Lorem.sentence(50, true) }
    tags_list { Faker::Lorem.words(4).join(",") }
    is_published { true }
    user
  end

  factory :comment do
    user
    post
    body { Faker::Lorem.sentence(50, true) }
  end

end
