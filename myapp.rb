require "roda"
require "sequel"

database = "grape-sequel_development"
user     = "postgres"
password = "123456"
DB = Sequel.connect(adapter: "postgres", database: database, host: "127.0.0.1", user: user, password: password)
class Myapp < Roda
  # ...
end