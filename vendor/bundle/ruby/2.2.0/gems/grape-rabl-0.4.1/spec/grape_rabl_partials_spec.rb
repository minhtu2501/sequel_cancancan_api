require 'spec_helper'

describe 'Grape::Rabl partials' do
  let(:parsed_response) { JSON.parse(last_response.body) }

  subject do
    Class.new(Grape::API)
  end

  before do
    subject.format :json
    subject.formatter :json, Grape::Formatter::Rabl
    subject.before { env['api.tilt.root'] = "#{File.dirname(__FILE__)}/views" }
  end

  def app
    subject
  end

  it 'proper render partials' do
    subject.get('/home', rabl: 'project') do
      @author   = OpenStruct.new(author: 'LTe')
      @type     = OpenStruct.new(type: 'paper')
      @project  = OpenStruct.new(name: 'First', type: @type, author: @author)
    end

    get('/home')
    parsed_response.should ==
      JSON.parse("{\"project\":{\"name\":\"First\",\"info\":{\"type\":\"paper\"},\"author\":{\"author\":\"LTe\"}}}")
  end
end
