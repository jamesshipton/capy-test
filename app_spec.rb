require_relative 'app'

require 'capybara/rspec'
require 'capybara/poltergeist'
require 'debugger'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, :phantomjs_options => ['--web-security=false'], :inspector => true)
end

Capybara.javascript_driver = :poltergeist

Capybara.app = CapyTest

describe 'rack test', type: :feature, js: true do
  it 'returns the rack response' do
    visit '/'
    # page.driver.debug
    puts page.body
  end
end
