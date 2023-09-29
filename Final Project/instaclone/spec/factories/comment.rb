FactoryBot.define do
  factory :comment do
    content { "This is a sample comment." }
    user
    post
  end
end
