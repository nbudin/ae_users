# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{illyan}
  s.version = "0.6.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Nat Budin"]
  s.date = %q{2010-04-14}
  s.description = %q{Illyan is an out-of-the-box setup for authentication, authorization, and (optionally)
single sign-on.  Rather than reinventing the wheel, Illyan uses popular and proven
solutions: Devise for authentication, acl9 for authorization, and CAS for single
sign-on.
}
  s.email = %q{natbudin@gmail.com}
  s.extra_rdoc_files = [
    "README"
  ]
  s.files = [
    ".gitignore",
     "README",
     "Rakefile",
     "VERSION",
     "app/controllers/account_controller.rb",
     "app/controllers/auth_controller.rb",
     "app/controllers/permission_controller.rb",
     "app/helpers/account_helper.rb",
     "app/helpers/illyan_helper.rb",
     "app/helpers/permission_helper.rb",
     "app/models/group.rb",
     "app/models/open_id_identity.rb",
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
     "app/views/auth_notifier/account_activation.rhtml",
     "app/views/auth_notifier/generated_password.rhtml",
     "app/views/permission/_add_grantee.rhtml",
     "app/views/permission/_role.html.erb",
     "app/views/permission/_show.rhtml",
     "app/views/permission/grant.rhtml",
     "app/views/person_sessions/_auth_form.rhtml",
     "app/views/person_sessions/_forgot_form.html.erb",
     "app/views/person_sessions/_mini_auth_form.rhtml",
     "app/views/person_sessions/_openid_auth_form.html.erb",
     "app/views/person_sessions/_other_login_options.html.erb",
     "app/views/person_sessions/auth_form.js.erb",
     "app/views/person_sessions/forgot.rhtml",
     "app/views/person_sessions/forgot_form.rhtml",
     "app/views/person_sessions/index.css.erb",
     "app/views/person_sessions/needs_activation.rhtml",
     "app/views/person_sessions/needs_person.html.erb",
     "app/views/person_sessions/needs_profile.rhtml",
     "app/views/person_sessions/new.html.erb",
     "app/views/person_sessions/openid_login.html.erb",
     "app/views/person_sessions/resend_activation.rhtml",
     "config/routes.rb",
     "generators/illyan/USAGE",
     "generators/illyan/illyan_generator.rb",
     "generators/illyan/templates/add.png",
     "generators/illyan/templates/admin.png",
     "generators/illyan/templates/group.png",
     "generators/illyan/templates/logout.png",
     "generators/illyan/templates/migration.rb",
     "generators/illyan/templates/openid.gif",
     "generators/illyan/templates/remove.png",
     "generators/illyan/templates/user.png",
     "generators/illyan_acl9_migration/USAGE",
     "generators/illyan_acl9_migration/illyan_acl9_migration_generator.rb",
     "generators/illyan_acl9_migration/templates/migrate_to_acl9.rb",
     "generators/illyan_devise_migration/USAGE",
     "generators/illyan_devise_migration/illyan_devise_migration_generator.rb",
     "generators/illyan_devise_migration/templates/migrate_to_devise.rb",
     "illyan.gemspec",
     "install.rb",
     "lib/illyan.rb",
     "lib/illyan/acts.rb",
     "lib/illyan/acts/shared_model.rb",
     "lib/illyan/controller_extensions.rb",
     "lib/illyan/form_builder_extensions.rb",
     "lib/illyan/instance_tag_extensions.rb",
     "lib/illyan/model_extensions.rb",
     "migrate_from_shared_database.sh",
     "rails/init.rb",
     "rails/tasks/ae_users_tasks.rake",
     "test/factories/groups.rb",
     "test/factories/people.rb",
     "test/factories/posts.rb",
     "test/illyan_test.rb",
     "test/rails_app/README",
     "test/rails_app/Rakefile",
     "test/rails_app/app/controllers/application_controller.rb",
     "test/rails_app/app/helpers/application_helper.rb",
     "test/rails_app/app/models/post.rb",
     "test/rails_app/config/boot.rb",
     "test/rails_app/config/database.yml",
     "test/rails_app/config/environment.rb",
     "test/rails_app/config/environments/development.rb",
     "test/rails_app/config/environments/production.rb",
     "test/rails_app/config/environments/test.rb",
     "test/rails_app/config/initializers/backtrace_silencers.rb",
     "test/rails_app/config/initializers/illyan.rb",
     "test/rails_app/config/initializers/inflections.rb",
     "test/rails_app/config/initializers/mime_types.rb",
     "test/rails_app/config/initializers/new_rails_defaults.rb",
     "test/rails_app/config/initializers/session_store.rb",
     "test/rails_app/config/locales/en.yml",
     "test/rails_app/config/routes.rb",
     "test/rails_app/db/migrate/001_create_posts.rb",
     "test/rails_app/db/seeds.rb",
     "test/rails_app/doc/README_FOR_APP",
     "test/rails_app/log/development.log",
     "test/rails_app/log/production.log",
     "test/rails_app/log/server.log",
     "test/rails_app/public/404.html",
     "test/rails_app/public/422.html",
     "test/rails_app/public/500.html",
     "test/rails_app/public/favicon.ico",
     "test/rails_app/public/images/rails.png",
     "test/rails_app/public/index.html",
     "test/rails_app/public/javascripts/application.js",
     "test/rails_app/public/javascripts/controls.js",
     "test/rails_app/public/javascripts/dragdrop.js",
     "test/rails_app/public/javascripts/effects.js",
     "test/rails_app/public/javascripts/prototype.js",
     "test/rails_app/public/robots.txt",
     "test/rails_app/script/about",
     "test/rails_app/script/console",
     "test/rails_app/script/dbconsole",
     "test/rails_app/script/destroy",
     "test/rails_app/script/generate",
     "test/rails_app/script/performance/benchmarker",
     "test/rails_app/script/performance/profiler",
     "test/rails_app/script/plugin",
     "test/rails_app/script/runner",
     "test/rails_app/script/server",
     "test/test_helper.rb",
     "test/unit/authorization_object_test.rb",
     "test/unit/person_test.rb",
     "uninstall.rb"
  ]
  s.homepage = %q{http://github.com/nbudin/ae_users}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Instant authentication, authorization, and SSO for Rails}
  s.test_files = [
    "test/rails_app/db/migrate/001_create_posts.rb",
     "test/rails_app/db/seeds.rb",
     "test/rails_app/app/controllers/application_controller.rb",
     "test/rails_app/app/helpers/application_helper.rb",
     "test/rails_app/app/models/post.rb",
     "test/rails_app/config/routes.rb",
     "test/rails_app/config/initializers/inflections.rb",
     "test/rails_app/config/initializers/illyan.rb",
     "test/rails_app/config/initializers/new_rails_defaults.rb",
     "test/rails_app/config/initializers/backtrace_silencers.rb",
     "test/rails_app/config/initializers/mime_types.rb",
     "test/rails_app/config/initializers/session_store.rb",
     "test/rails_app/config/environments/test.rb",
     "test/rails_app/config/environments/development.rb",
     "test/rails_app/config/environments/production.rb",
     "test/rails_app/config/environment.rb",
     "test/rails_app/config/boot.rb",
     "test/unit/authorization_object_test.rb",
     "test/unit/person_test.rb",
     "test/factories/groups.rb",
     "test/factories/people.rb",
     "test/factories/posts.rb",
     "test/illyan_test.rb",
     "test/test_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<acl9>, [">= 0"])
      s.add_runtime_dependency(%q<devise>, ["~> 1.0.6"])
      s.add_runtime_dependency(%q<rack-openid>, [">= 0"])
    else
      s.add_dependency(%q<acl9>, [">= 0"])
      s.add_dependency(%q<devise>, ["~> 1.0.6"])
      s.add_dependency(%q<rack-openid>, [">= 0"])
    end
  else
    s.add_dependency(%q<acl9>, [">= 0"])
    s.add_dependency(%q<devise>, ["~> 1.0.6"])
    s.add_dependency(%q<rack-openid>, [">= 0"])
  end
end

