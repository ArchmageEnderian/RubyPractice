FactoryBot.define do
  factory :story do
    description { 'Sample story description' }
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/sample_image.jpg'), 'image/jpg') }
    user
  end
end
