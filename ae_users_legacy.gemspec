# Generated by jeweler
# DO NOT EDIT THIS FILE
# Instead, edit Jeweler::Tasks in Rakefile, and run `rake gemspec`
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ae_users_legacy}
  s.version = "0.6.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Nat Budin"]
  s.date = %q{2011-03-29}
  s.description = %q{Don't use this gem.  Use something written in the last couple years instead.}
  s.email = %q{natbudin@gmail.com}
  s.extra_rdoc_files = [
    "README"
  ]
  s.files = [
    "README",
     "Rakefile",
     "VERSION",
     "app/controllers/account_controller.rb",
     "app/controllers/auth_controller.rb",
     "app/controllers/permission_controller.rb",
     "app/helpers/account_helper.rb",
     "app/helpers/auth_helper.rb",
     "app/helpers/permission_helper.rb",
     "app/models/account.rb",
     "app/models/auth_notifier.rb",
     "app/models/auth_ticket.rb",
     "app/models/email_address.rb",
     "app/models/login.rb",
     "app/models/open_id_identity.rb",
     "app/models/permission.rb",
     "app/models/person.rb",
     "app/models/role.rb",
     "app/views/account/_personal_info.rhtml",
     "app/views/account/_procon_profile.rhtml",
     "app/views/account/_signup_form.html.erb",
     "app/views/account/activate.rhtml",
     "app/views/account/activation_error.rhtml",
     "app/views/account/change_password.rhtml",
     "app/views/account/edit_profile.rhtml",
     "app/views/account/signup.rhtml",
     "app/views/account/signup_noactivation.rhtml",
     "app/views/account/signup_success.rhtml",
     "app/views/auth/_auth_form.rhtml",
     "app/views/auth/_forgot_form.html.erb",
     "app/views/auth/_mini_auth_form.rhtml",
     "app/views/auth/_openid_auth_form.html.erb",
     "app/views/auth/_other_login_options.html.erb",
     "app/views/auth/auth_form.js.erb",
     "app/views/auth/forgot.rhtml",
     "app/views/auth/forgot_form.rhtml",
     "app/views/auth/index.css.erb",
     "app/views/auth/login.rhtml",
     "app/views/auth/needs_activation.rhtml",
     "app/views/auth/needs_person.html.erb",
     "app/views/auth/needs_profile.rhtml",
     "app/views/auth/openid_login.html.erb",
     "app/views/auth/resend_activation.rhtml",
     "app/views/auth_notifier/account_activation.rhtml",
     "app/views/auth_notifier/generated_password.rhtml",
     "app/views/permission/_add_grantee.rhtml",
     "app/views/permission/_role_member.rhtml",
     "app/views/permission/_show.rhtml",
     "app/views/permission/_userpicker.rhtml",
     "app/views/permission/add_role_member.rhtml",
     "app/views/permission/admin.rhtml",
     "app/views/permission/edit.rhtml",
     "app/views/permission/edit_role.rhtml",
     "app/views/permission/grant.rhtml",
     "db/migrate/002_create_accounts.rb",
     "db/migrate/003_create_email_addresses.rb",
     "db/migrate/004_create_people.rb",
     "db/migrate/013_simplify_signup.rb",
     "db/migrate/014_create_permissions.rb",
     "db/migrate/015_create_roles.rb",
     "db/migrate/016_refactor_people.rb",
     "db/migrate/017_people_permissions.rb",
     "init.rb",
     "install.rb",
     "lib/ae_users.rb",
     "rails/init.rb",
     "schema.sql",
     "test/ae_users_test.rb",
     "uninstall.rb"
  ]
  s.homepage = %q{http://github.com/nbudin/ae_users}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Legacy authentication/authorization framework}
  s.test_files = [
    "test/ae_users_test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<thoughtbot-shoulda>, [">= 0"])
      s.add_runtime_dependency(%q<ruby-openid>, [">= 2.0.4"])
    else
      s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
      s.add_dependency(%q<ruby-openid>, [">= 2.0.4"])
    end
  else
    s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
    s.add_dependency(%q<ruby-openid>, [">= 2.0.4"])
  end
end
