#!/usr/bin/ruby

require 'yajl'
require 'active_support'
require './app/api/concerns/api_extensions.rb'
require 'sequel'
require 'grape'
require 'cancancan'
require 'grape-rabl'
require 'pry'
require './app/errors/unauthorized.rb'
Dir["./app/api/v1/*.rb"].each {|file| require file}
class RootV1 < Grape::API
  include APIExtensions
  prefix "api"
  version "v1", using: :path
  format :json
  formatter :json, Grape::Formatter::Rabl
  content_type :json, "application/json;charset=UTF-8"

  mount RootV1::V1::UserAPI
  mount RootV1::V1::RoleAPI
  mount RootV1::V1::AuthAPI
end