RSpec.configure do |config|

  # before all tests at all
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    # puts Product.count
    #DatabaseCleaner.strategy = :transaction #now we use postgres for tests
    DatabaseCleaner.strategy = :deletion #avoid locks for sqlite
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation #use this for features non-rack tests
    #DatabaseCleaner.strategy = :deletion #avoid locks for sqlite
  end

  config.before(:each, disable_transactions: true) do
    DatabaseCleaner.strategy = :truncation #use this for features non-rack tests
    #DatabaseCleaner.strategy = :deletion #avoid locks for sqlite
  end
      
  config.before(:each) do
    DatabaseCleaner.start
  end

  config.append_after(:each) do
    #Warden.test_reset!
    DatabaseCleaner.clean
  end
end
