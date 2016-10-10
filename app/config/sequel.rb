DB = Sequel.connect(ENV.fetch('DATABASE_URL'))

Sequel.extension :migration
Sequel::Migrator.check_current(DB, './/app/migrations')

Sequel::Model.plugin :timestamps
