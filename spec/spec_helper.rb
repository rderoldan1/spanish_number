require 'rubygems'
require 'bundler/setup'
require 'coveralls'

Coveralls.wear!

require File.expand_path('../array', __FILE__)
require File.expand_path('../../lib/spanish_number', __FILE__)

I18n.locale = :es
RSpec.configure do |config|
end
