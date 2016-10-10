desc "Start the console"
task :console do
  exec 'irb -r ./app/routes/main.rb'
end

desc "Create the database"
task :create do
end

desc "Drop the database"
task :drop do
end

desc "Dump the schema"
task :dump do
  `sequel -D #{ENV.fetch("DATABASE_URL")} > app/config/001_schema.rb`
end

desc "Load the schema"
task :load do
  `sequel -m app/config #{ENV.fetch("DATABASE_URL")}`
end

desc "Run migrations"
task :migrate, [:version] do |t, args|
  require "sequel"
  Sequel.extension :migration
  db = Sequel.connect(ENV.fetch("DATABASE_URL"))
  if args[:version]
    puts "Migrating to version #{args[:version]}"
    Sequel::Migrator.run(db, "app/migrations", target: args[:version].to_i)
  else
    puts "Migrating to latest"
    Sequel::Migrator.run(db, "app/migrations")
  end
end
