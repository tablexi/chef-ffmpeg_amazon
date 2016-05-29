require 'chefspec'
require 'chefspec/berkshelf'

require_relative 'support/matchers'

RSpec.configure do |config|
  config.platform = 'amazon'
  config.version = '2015.09'
end

at_exit { ChefSpec::Coverage.report! }
