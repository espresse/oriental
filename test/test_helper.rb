ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'rack/test'

module TestHelper
  SERVER        = { host: 'localhost', port: 2424 }
  SERVER_USER   = { user: 'root', password: 'root' }

  TEST_DB       = { db: 'oriental-test', storage: "memory" }
  TEST_DB_USER  = { user: 'admin', password: 'admin' }
end

server = OrientdbBinary::Server.new(TestHelper::SERVER)
server.connect(TestHelper::SERVER_USER)

if server.db_exists? TestHelper::TEST_DB[:db]
  server.db_drop TestHelper::TEST_DB[:db], TestHelper::TEST_DB[:storage]
end
server.db_create(TestHelper::TEST_DB[:db], 'document', TestHelper::TEST_DB[:storage])
server.disconnect
Oriental::Connection.connect(host: 'localhost', port: 2424, db: 'oriental-test', db_user: "admin", db_password: "admin", storage: "memory")
  

class OUser < Struct.new(:parameters)
end
