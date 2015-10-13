load File.join(File.dirname(__FILE__), "application.rb")

application = Application.new

application.init_env

namespace :db do
  desc "Migrate the database"
  task :migrate do
    ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
  end
end
