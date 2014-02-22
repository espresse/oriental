require 'yaml'
require 'singleton'

module Oriental
  class Connection
    attr_accessor :database

    def self.connect(*args, &block)
      return @instance if @instance
      @instance = allocate
      @instance.initialize_connection(*args, &block)
    end

    def initialize_connection(settings)
      connection = {
        host: settings[:host],
        port: settings[:port]
      }

      database_info = {
        db: settings[:db],
        user: settings[:db_user],
        password: settings[:db_password],
        storage: settings[:storage]
      }

      @database = OrientdbBinary::Database.new(connection)
      @database.open(database_info)
      self
    end

    class << self
      private :new
    end
  end
end
