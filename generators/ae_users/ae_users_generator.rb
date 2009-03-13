class AeUsersGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.directory "public/images/ae_users"
      %w{add admin group logout remove user}.each do |img|
        m.file "#{img}.png", "public/images/ae_users/#{img}.png"
      end
      m.file "openid.gif", "public/images/ae_users/openid.gif"
    end
  end
end
