$:.unshift "./app"

# require 'models'
require 'api/root_v1'
require 'models/user'
require 'models/ability'
require 'models/api_key'
require 'models/role'
require 'models/permission'
use Rack::Config do |env|
  env['api.tilt.root'] = 'app/views/api'
end
Grape::Rabl.configure do |config|
  config.cache_template_loading = true # default: false
end
run RootV1
