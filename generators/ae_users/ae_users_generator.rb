class AeUsersGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.directory "public/images/ae_users"
      %w{add admin group logout remove user}.each do |img|
        m.file "#{img}.png", "public/images/ae_users/#{img}.png"
      end
      m.migration_template 'migration.rb', "db/migrate", :migration_file_name => 'ae_users_local_tables'
    end
  end
end
