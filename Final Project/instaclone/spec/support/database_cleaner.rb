RSpec.configure do |config|
  DatabaseCleaner.clean_with(:truncation)
end