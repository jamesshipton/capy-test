require_relative 'app'
require 'capybara/rspec'

Capybara.app = CapyTest

describe 'rack test', type: :feature do
  it 'returns the rack response' do
    visit '/'
  end
end