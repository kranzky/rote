module Sequel
  class Database
    def log_connection_yield(sql, conn, args=nil, &block)
      if conn && log_connection_info
        @loggers.first.tagged(conn.__id__) do
          log_semantic(sql, args, &block)
        end
      else
        log_semantic(sql, args, &block)
      end
    end
    def log_semantic(sql, args)
      message = "#{sql}#{"; #{args.inspect}" if args}"
      if log_warn_duration
        @loggers.first.measure_warn(message, { min_duration: log_warn_duration }) do
          yield
        end
      else
        @loggers.first.measure_trace(message) do
          yield
        end
      end
    end
  end
end

DB = Sequel.connect(ENV.fetch('DATABASE_URL'), logger: SemanticLogger['Sequel'], log_connection_info: true, log_warn_duration: nil)

Sequel.extension :migration
Sequel::Migrator.check_current(DB, './app/migrations')

Sequel::Model.plugin :timestamps
