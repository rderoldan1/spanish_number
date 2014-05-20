require 'rspec'
require 'spec_helper'
require 'array'

describe 'Helper methods' do
	TEST.each do |number|
		it "should translate a number = #{number}" do
			number[0].to_spanish_text(format: :short).strip.should eq number[1]
		end
	end
end

describe 'Colombian Pesos' do
	it 'should convert a number to colombian pesos in words' do
		12.30.to_spanish_text(format: :long, currency: :cop).strip.should eq 'doce pesos con treinta centavos'
		12.30.to_spanish_text(format: :short, currency: :cop).strip.should eq 'doce pesos'
	end
end