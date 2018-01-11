source 'https://rubygems.org'

gem 'rake'
ruby File.open(File.expand_path('.ruby-version', File.dirname(__FILE__))) { |f| f.read.chomp }

group :lint do
  gem 'rubocop'
  gem 'foodcritic'
end

group :unit, :integration do
  gem 'berkshelf'
end

group :unit do
  gem 'chefspec'
  gem 'rspec-expectations'
end

group :integration do
  gem 'test-kitchen'
  gem 'kitchen-vagrant'
  gem 'kitchen-ec2'
  gem 'serverspec'
end
