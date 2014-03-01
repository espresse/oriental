ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'rack/test'

Oriental::Connection.connect(host: 'localhost', port: 2424, db: 'GratefulDeadConcerts', db_user: "admin", db_password: "admin", storage: "plocal")

class OUser < Struct.new(:parameters)
end

