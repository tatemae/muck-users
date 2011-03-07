# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{muck-users}
  s.version = "3.1.22"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Justin Ball", "Joel Duffin"]
  s.date = %q{2011-03-07}
  s.description = %q{Easily add user signup, login and other features to your application}
  s.email = %q{justin@tatemae.com}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    "MIT-LICENSE",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "app/controllers/admin/muck/access_code_requests_controller.rb",
    "app/controllers/admin/muck/access_codes_controller.rb",
    "app/controllers/admin/muck/roles_controller.rb",
    "app/controllers/admin/muck/users_controller.rb",
    "app/controllers/muck/access_code_requests_controller.rb",
    "app/controllers/muck/activations_controller.rb",
    "app/controllers/muck/password_resets_controller.rb",
    "app/controllers/muck/user_sessions_controller.rb",
    "app/controllers/muck/username_request_controller.rb",
    "app/controllers/muck/users_controller.rb",
    "app/helpers/muck_users_helper.rb",
    "app/models/permission.rb",
    "app/models/role.rb",
    "app/views/access_code_requests/create.js.erb",
    "app/views/access_code_requests/new.html.erb",
    "app/views/access_code_requests/show.html.erb",
    "app/views/admin/access_code_requests/_access_code_request.erb",
    "app/views/admin/access_code_requests/_form.erb",
    "app/views/admin/access_code_requests/ajax_update_access_code_request.js.erb",
    "app/views/admin/access_code_requests/destroy.js.erb",
    "app/views/admin/access_code_requests/edit.erb",
    "app/views/admin/access_code_requests/index.html.erb",
    "app/views/admin/access_code_requests/send_code.erb",
    "app/views/admin/access_codes/_access_code.html.erb",
    "app/views/admin/access_codes/_access_code_nav.html.erb",
    "app/views/admin/access_codes/_form.erb",
    "app/views/admin/access_codes/_user.erb",
    "app/views/admin/access_codes/ajax_create_access_code.js.erb",
    "app/views/admin/access_codes/ajax_update_access_code.js.erb",
    "app/views/admin/access_codes/bulk.html.erb",
    "app/views/admin/access_codes/destroy.js.erb",
    "app/views/admin/access_codes/edit.erb",
    "app/views/admin/access_codes/index.html.erb",
    "app/views/admin/access_codes/new.erb",
    "app/views/admin/access_codes/show.html.erb",
    "app/views/admin/permissions/_permission.html.erb",
    "app/views/admin/roles/_role.html.erb",
    "app/views/admin/roles/ajax_update_roles.js.erb",
    "app/views/admin/roles/destroy.js.erb",
    "app/views/admin/roles/edit.html.erb",
    "app/views/admin/roles/index.html.erb",
    "app/views/admin/roles/new.html.erb",
    "app/views/admin/roles/show.html.erb",
    "app/views/admin/users/_activate.html.erb",
    "app/views/admin/users/_dashboard_widget.html.erb",
    "app/views/admin/users/_row.html.erb",
    "app/views/admin/users/_search_box.html.erb",
    "app/views/admin/users/_table.erb",
    "app/views/admin/users/_user_navigation.html.erb",
    "app/views/admin/users/do_search.html.erb",
    "app/views/admin/users/edit.html.erb",
    "app/views/admin/users/inactive.html.erb",
    "app/views/admin/users/inactive_emails.html.erb",
    "app/views/admin/users/index.csv.erb",
    "app/views/admin/users/index.html.erb",
    "app/views/admin/users/permissions.html.erb",
    "app/views/admin/users/row.js.erb",
    "app/views/admin/users/search.html.erb",
    "app/views/admin/users/search.js.erb",
    "app/views/password_resets/edit.html.erb",
    "app/views/password_resets/new.html.erb",
    "app/views/user_mailer/access_code.ar.html.erb",
    "app/views/user_mailer/access_code.bg.html.erb",
    "app/views/user_mailer/access_code.ca.html.erb",
    "app/views/user_mailer/access_code.cs.html.erb",
    "app/views/user_mailer/access_code.da.html.erb",
    "app/views/user_mailer/access_code.de.html.erb",
    "app/views/user_mailer/access_code.el.html.erb",
    "app/views/user_mailer/access_code.es.html.erb",
    "app/views/user_mailer/access_code.et.html.erb",
    "app/views/user_mailer/access_code.fa.html.erb",
    "app/views/user_mailer/access_code.fi.html.erb",
    "app/views/user_mailer/access_code.fr.html.erb",
    "app/views/user_mailer/access_code.gl.html.erb",
    "app/views/user_mailer/access_code.hi.html.erb",
    "app/views/user_mailer/access_code.hr.html.erb",
    "app/views/user_mailer/access_code.ht.html.erb",
    "app/views/user_mailer/access_code.html.erb",
    "app/views/user_mailer/access_code.hu.html.erb",
    "app/views/user_mailer/access_code.id.html.erb",
    "app/views/user_mailer/access_code.it.html.erb",
    "app/views/user_mailer/access_code.iw.html.erb",
    "app/views/user_mailer/access_code.ja.html.erb",
    "app/views/user_mailer/access_code.ko.html.erb",
    "app/views/user_mailer/access_code.lt.html.erb",
    "app/views/user_mailer/access_code.lv.html.erb",
    "app/views/user_mailer/access_code.mt.html.erb",
    "app/views/user_mailer/access_code.nl.html.erb",
    "app/views/user_mailer/access_code.no.html.erb",
    "app/views/user_mailer/access_code.pl.html.erb",
    "app/views/user_mailer/access_code.pt-PT.html.erb",
    "app/views/user_mailer/access_code.ro.html.erb",
    "app/views/user_mailer/access_code.ru.html.erb",
    "app/views/user_mailer/access_code.sk.html.erb",
    "app/views/user_mailer/access_code.sl.html.erb",
    "app/views/user_mailer/access_code.sq.html.erb",
    "app/views/user_mailer/access_code.sr.html.erb",
    "app/views/user_mailer/access_code.sv.html.erb",
    "app/views/user_mailer/access_code.text.erb",
    "app/views/user_mailer/access_code.th.html.erb",
    "app/views/user_mailer/access_code.tl.html.erb",
    "app/views/user_mailer/access_code.tr.html.erb",
    "app/views/user_mailer/access_code.uk.html.erb",
    "app/views/user_mailer/access_code.vi.html.erb",
    "app/views/user_mailer/access_code.zh-CN.html.erb",
    "app/views/user_mailer/access_code.zh-TW.html.erb",
    "app/views/user_mailer/access_code.zh.html.erb",
    "app/views/user_mailer/activation_confirmation.ar.html.erb",
    "app/views/user_mailer/activation_confirmation.bg.html.erb",
    "app/views/user_mailer/activation_confirmation.ca.html.erb",
    "app/views/user_mailer/activation_confirmation.cs.html.erb",
    "app/views/user_mailer/activation_confirmation.da.html.erb",
    "app/views/user_mailer/activation_confirmation.de.html.erb",
    "app/views/user_mailer/activation_confirmation.el.html.erb",
    "app/views/user_mailer/activation_confirmation.es.html.erb",
    "app/views/user_mailer/activation_confirmation.et.html.erb",
    "app/views/user_mailer/activation_confirmation.fa.html.erb",
    "app/views/user_mailer/activation_confirmation.fi.html.erb",
    "app/views/user_mailer/activation_confirmation.fr.html.erb",
    "app/views/user_mailer/activation_confirmation.gl.html.erb",
    "app/views/user_mailer/activation_confirmation.hi.html.erb",
    "app/views/user_mailer/activation_confirmation.hr.html.erb",
    "app/views/user_mailer/activation_confirmation.ht.html.erb",
    "app/views/user_mailer/activation_confirmation.html.erb",
    "app/views/user_mailer/activation_confirmation.hu.html.erb",
    "app/views/user_mailer/activation_confirmation.id.html.erb",
    "app/views/user_mailer/activation_confirmation.it.html.erb",
    "app/views/user_mailer/activation_confirmation.iw.html.erb",
    "app/views/user_mailer/activation_confirmation.ja.html.erb",
    "app/views/user_mailer/activation_confirmation.ko.html.erb",
    "app/views/user_mailer/activation_confirmation.lt.html.erb",
    "app/views/user_mailer/activation_confirmation.lv.html.erb",
    "app/views/user_mailer/activation_confirmation.mt.html.erb",
    "app/views/user_mailer/activation_confirmation.nl.html.erb",
    "app/views/user_mailer/activation_confirmation.no.html.erb",
    "app/views/user_mailer/activation_confirmation.pl.html.erb",
    "app/views/user_mailer/activation_confirmation.pt-PT.html.erb",
    "app/views/user_mailer/activation_confirmation.ro.html.erb",
    "app/views/user_mailer/activation_confirmation.ru.html.erb",
    "app/views/user_mailer/activation_confirmation.sk.html.erb",
    "app/views/user_mailer/activation_confirmation.sl.html.erb",
    "app/views/user_mailer/activation_confirmation.sq.html.erb",
    "app/views/user_mailer/activation_confirmation.sr.html.erb",
    "app/views/user_mailer/activation_confirmation.sv.html.erb",
    "app/views/user_mailer/activation_confirmation.text.erb",
    "app/views/user_mailer/activation_confirmation.th.html.erb",
    "app/views/user_mailer/activation_confirmation.tl.html.erb",
    "app/views/user_mailer/activation_confirmation.tr.html.erb",
    "app/views/user_mailer/activation_confirmation.uk.html.erb",
    "app/views/user_mailer/activation_confirmation.vi.html.erb",
    "app/views/user_mailer/activation_confirmation.zh-CN.html.erb",
    "app/views/user_mailer/activation_confirmation.zh-TW.html.erb",
    "app/views/user_mailer/activation_confirmation.zh.html.erb",
    "app/views/user_mailer/activation_instructions.ar.html.erb",
    "app/views/user_mailer/activation_instructions.bg.html.erb",
    "app/views/user_mailer/activation_instructions.ca.html.erb",
    "app/views/user_mailer/activation_instructions.cs.html.erb",
    "app/views/user_mailer/activation_instructions.da.html.erb",
    "app/views/user_mailer/activation_instructions.de.html.erb",
    "app/views/user_mailer/activation_instructions.el.html.erb",
    "app/views/user_mailer/activation_instructions.es.html.erb",
    "app/views/user_mailer/activation_instructions.et.html.erb",
    "app/views/user_mailer/activation_instructions.fa.html.erb",
    "app/views/user_mailer/activation_instructions.fi.html.erb",
    "app/views/user_mailer/activation_instructions.fr.html.erb",
    "app/views/user_mailer/activation_instructions.gl.html.erb",
    "app/views/user_mailer/activation_instructions.hi.html.erb",
    "app/views/user_mailer/activation_instructions.hr.html.erb",
    "app/views/user_mailer/activation_instructions.ht.html.erb",
    "app/views/user_mailer/activation_instructions.html.erb",
    "app/views/user_mailer/activation_instructions.hu.html.erb",
    "app/views/user_mailer/activation_instructions.id.html.erb",
    "app/views/user_mailer/activation_instructions.it.html.erb",
    "app/views/user_mailer/activation_instructions.iw.html.erb",
    "app/views/user_mailer/activation_instructions.ja.html.erb",
    "app/views/user_mailer/activation_instructions.ko.html.erb",
    "app/views/user_mailer/activation_instructions.lt.html.erb",
    "app/views/user_mailer/activation_instructions.lv.html.erb",
    "app/views/user_mailer/activation_instructions.mt.html.erb",
    "app/views/user_mailer/activation_instructions.nl.html.erb",
    "app/views/user_mailer/activation_instructions.no.html.erb",
    "app/views/user_mailer/activation_instructions.pl.html.erb",
    "app/views/user_mailer/activation_instructions.pt-PT.html.erb",
    "app/views/user_mailer/activation_instructions.ro.html.erb",
    "app/views/user_mailer/activation_instructions.ru.html.erb",
    "app/views/user_mailer/activation_instructions.sk.html.erb",
    "app/views/user_mailer/activation_instructions.sl.html.erb",
    "app/views/user_mailer/activation_instructions.sq.html.erb",
    "app/views/user_mailer/activation_instructions.sr.html.erb",
    "app/views/user_mailer/activation_instructions.sv.html.erb",
    "app/views/user_mailer/activation_instructions.text.erb",
    "app/views/user_mailer/activation_instructions.th.html.erb",
    "app/views/user_mailer/activation_instructions.tl.html.erb",
    "app/views/user_mailer/activation_instructions.tr.html.erb",
    "app/views/user_mailer/activation_instructions.uk.html.erb",
    "app/views/user_mailer/activation_instructions.vi.html.erb",
    "app/views/user_mailer/activation_instructions.zh-CN.html.erb",
    "app/views/user_mailer/activation_instructions.zh-TW.html.erb",
    "app/views/user_mailer/activation_instructions.zh.html.erb",
    "app/views/user_mailer/password_not_active_instructions.ar.html.erb",
    "app/views/user_mailer/password_not_active_instructions.bg.html.erb",
    "app/views/user_mailer/password_not_active_instructions.ca.html.erb",
    "app/views/user_mailer/password_not_active_instructions.cs.html.erb",
    "app/views/user_mailer/password_not_active_instructions.da.html.erb",
    "app/views/user_mailer/password_not_active_instructions.de.html.erb",
    "app/views/user_mailer/password_not_active_instructions.el.html.erb",
    "app/views/user_mailer/password_not_active_instructions.es.html.erb",
    "app/views/user_mailer/password_not_active_instructions.et.html.erb",
    "app/views/user_mailer/password_not_active_instructions.fa.html.erb",
    "app/views/user_mailer/password_not_active_instructions.fi.html.erb",
    "app/views/user_mailer/password_not_active_instructions.fr.html.erb",
    "app/views/user_mailer/password_not_active_instructions.gl.html.erb",
    "app/views/user_mailer/password_not_active_instructions.hi.html.erb",
    "app/views/user_mailer/password_not_active_instructions.hr.html.erb",
    "app/views/user_mailer/password_not_active_instructions.ht.html.erb",
    "app/views/user_mailer/password_not_active_instructions.html.erb",
    "app/views/user_mailer/password_not_active_instructions.hu.html.erb",
    "app/views/user_mailer/password_not_active_instructions.id.html.erb",
    "app/views/user_mailer/password_not_active_instructions.it.html.erb",
    "app/views/user_mailer/password_not_active_instructions.iw.html.erb",
    "app/views/user_mailer/password_not_active_instructions.ja.html.erb",
    "app/views/user_mailer/password_not_active_instructions.ko.html.erb",
    "app/views/user_mailer/password_not_active_instructions.lt.html.erb",
    "app/views/user_mailer/password_not_active_instructions.lv.html.erb",
    "app/views/user_mailer/password_not_active_instructions.mt.html.erb",
    "app/views/user_mailer/password_not_active_instructions.nl.html.erb",
    "app/views/user_mailer/password_not_active_instructions.no.html.erb",
    "app/views/user_mailer/password_not_active_instructions.pl.html.erb",
    "app/views/user_mailer/password_not_active_instructions.pt-PT.html.erb",
    "app/views/user_mailer/password_not_active_instructions.ro.html.erb",
    "app/views/user_mailer/password_not_active_instructions.ru.html.erb",
    "app/views/user_mailer/password_not_active_instructions.sk.html.erb",
    "app/views/user_mailer/password_not_active_instructions.sl.html.erb",
    "app/views/user_mailer/password_not_active_instructions.sq.html.erb",
    "app/views/user_mailer/password_not_active_instructions.sr.html.erb",
    "app/views/user_mailer/password_not_active_instructions.sv.html.erb",
    "app/views/user_mailer/password_not_active_instructions.text.erb",
    "app/views/user_mailer/password_not_active_instructions.th.html.erb",
    "app/views/user_mailer/password_not_active_instructions.tl.html.erb",
    "app/views/user_mailer/password_not_active_instructions.tr.html.erb",
    "app/views/user_mailer/password_not_active_instructions.uk.html.erb",
    "app/views/user_mailer/password_not_active_instructions.vi.html.erb",
    "app/views/user_mailer/password_not_active_instructions.zh-CN.html.erb",
    "app/views/user_mailer/password_not_active_instructions.zh-TW.html.erb",
    "app/views/user_mailer/password_not_active_instructions.zh.html.erb",
    "app/views/user_mailer/password_reset_instructions.ar.html.erb",
    "app/views/user_mailer/password_reset_instructions.bg.html.erb",
    "app/views/user_mailer/password_reset_instructions.ca.html.erb",
    "app/views/user_mailer/password_reset_instructions.cs.html.erb",
    "app/views/user_mailer/password_reset_instructions.da.html.erb",
    "app/views/user_mailer/password_reset_instructions.de.html.erb",
    "app/views/user_mailer/password_reset_instructions.el.html.erb",
    "app/views/user_mailer/password_reset_instructions.es.html.erb",
    "app/views/user_mailer/password_reset_instructions.et.html.erb",
    "app/views/user_mailer/password_reset_instructions.fa.html.erb",
    "app/views/user_mailer/password_reset_instructions.fi.html.erb",
    "app/views/user_mailer/password_reset_instructions.fr.html.erb",
    "app/views/user_mailer/password_reset_instructions.gl.html.erb",
    "app/views/user_mailer/password_reset_instructions.hi.html.erb",
    "app/views/user_mailer/password_reset_instructions.hr.html.erb",
    "app/views/user_mailer/password_reset_instructions.ht.html.erb",
    "app/views/user_mailer/password_reset_instructions.html.erb",
    "app/views/user_mailer/password_reset_instructions.hu.html.erb",
    "app/views/user_mailer/password_reset_instructions.id.html.erb",
    "app/views/user_mailer/password_reset_instructions.it.html.erb",
    "app/views/user_mailer/password_reset_instructions.iw.html.erb",
    "app/views/user_mailer/password_reset_instructions.ja.html.erb",
    "app/views/user_mailer/password_reset_instructions.ko.html.erb",
    "app/views/user_mailer/password_reset_instructions.lt.html.erb",
    "app/views/user_mailer/password_reset_instructions.lv.html.erb",
    "app/views/user_mailer/password_reset_instructions.mt.html.erb",
    "app/views/user_mailer/password_reset_instructions.nl.html.erb",
    "app/views/user_mailer/password_reset_instructions.no.html.erb",
    "app/views/user_mailer/password_reset_instructions.pl.html.erb",
    "app/views/user_mailer/password_reset_instructions.pt-PT.html.erb",
    "app/views/user_mailer/password_reset_instructions.ro.html.erb",
    "app/views/user_mailer/password_reset_instructions.ru.html.erb",
    "app/views/user_mailer/password_reset_instructions.sk.html.erb",
    "app/views/user_mailer/password_reset_instructions.sl.html.erb",
    "app/views/user_mailer/password_reset_instructions.sq.html.erb",
    "app/views/user_mailer/password_reset_instructions.sr.html.erb",
    "app/views/user_mailer/password_reset_instructions.sv.html.erb",
    "app/views/user_mailer/password_reset_instructions.text.erb",
    "app/views/user_mailer/password_reset_instructions.th.html.erb",
    "app/views/user_mailer/password_reset_instructions.tl.html.erb",
    "app/views/user_mailer/password_reset_instructions.tr.html.erb",
    "app/views/user_mailer/password_reset_instructions.uk.html.erb",
    "app/views/user_mailer/password_reset_instructions.vi.html.erb",
    "app/views/user_mailer/password_reset_instructions.zh-CN.html.erb",
    "app/views/user_mailer/password_reset_instructions.zh-TW.html.erb",
    "app/views/user_mailer/password_reset_instructions.zh.html.erb",
    "app/views/user_mailer/username_request.ar.html.erb",
    "app/views/user_mailer/username_request.bg.html.erb",
    "app/views/user_mailer/username_request.ca.html.erb",
    "app/views/user_mailer/username_request.cs.html.erb",
    "app/views/user_mailer/username_request.da.html.erb",
    "app/views/user_mailer/username_request.de.html.erb",
    "app/views/user_mailer/username_request.el.html.erb",
    "app/views/user_mailer/username_request.es.html.erb",
    "app/views/user_mailer/username_request.et.html.erb",
    "app/views/user_mailer/username_request.fa.html.erb",
    "app/views/user_mailer/username_request.fi.html.erb",
    "app/views/user_mailer/username_request.fr.html.erb",
    "app/views/user_mailer/username_request.gl.html.erb",
    "app/views/user_mailer/username_request.hi.html.erb",
    "app/views/user_mailer/username_request.hr.html.erb",
    "app/views/user_mailer/username_request.ht.html.erb",
    "app/views/user_mailer/username_request.html.erb",
    "app/views/user_mailer/username_request.hu.html.erb",
    "app/views/user_mailer/username_request.id.html.erb",
    "app/views/user_mailer/username_request.it.html.erb",
    "app/views/user_mailer/username_request.iw.html.erb",
    "app/views/user_mailer/username_request.ja.html.erb",
    "app/views/user_mailer/username_request.ko.html.erb",
    "app/views/user_mailer/username_request.lt.html.erb",
    "app/views/user_mailer/username_request.lv.html.erb",
    "app/views/user_mailer/username_request.mt.html.erb",
    "app/views/user_mailer/username_request.nl.html.erb",
    "app/views/user_mailer/username_request.no.html.erb",
    "app/views/user_mailer/username_request.pl.html.erb",
    "app/views/user_mailer/username_request.pt-PT.html.erb",
    "app/views/user_mailer/username_request.ro.html.erb",
    "app/views/user_mailer/username_request.ru.html.erb",
    "app/views/user_mailer/username_request.sk.html.erb",
    "app/views/user_mailer/username_request.sl.html.erb",
    "app/views/user_mailer/username_request.sq.html.erb",
    "app/views/user_mailer/username_request.sr.html.erb",
    "app/views/user_mailer/username_request.sv.html.erb",
    "app/views/user_mailer/username_request.text.erb",
    "app/views/user_mailer/username_request.th.html.erb",
    "app/views/user_mailer/username_request.tl.html.erb",
    "app/views/user_mailer/username_request.tr.html.erb",
    "app/views/user_mailer/username_request.uk.html.erb",
    "app/views/user_mailer/username_request.vi.html.erb",
    "app/views/user_mailer/username_request.zh-CN.html.erb",
    "app/views/user_mailer/username_request.zh-TW.html.erb",
    "app/views/user_mailer/username_request.zh.html.erb",
    "app/views/user_mailer/welcome_notification.ar.html.erb",
    "app/views/user_mailer/welcome_notification.bg.html.erb",
    "app/views/user_mailer/welcome_notification.ca.html.erb",
    "app/views/user_mailer/welcome_notification.cs.html.erb",
    "app/views/user_mailer/welcome_notification.da.html.erb",
    "app/views/user_mailer/welcome_notification.de.html.erb",
    "app/views/user_mailer/welcome_notification.el.html.erb",
    "app/views/user_mailer/welcome_notification.es.html.erb",
    "app/views/user_mailer/welcome_notification.et.html.erb",
    "app/views/user_mailer/welcome_notification.fa.html.erb",
    "app/views/user_mailer/welcome_notification.fi.html.erb",
    "app/views/user_mailer/welcome_notification.fr.html.erb",
    "app/views/user_mailer/welcome_notification.gl.html.erb",
    "app/views/user_mailer/welcome_notification.hi.html.erb",
    "app/views/user_mailer/welcome_notification.hr.html.erb",
    "app/views/user_mailer/welcome_notification.ht.html.erb",
    "app/views/user_mailer/welcome_notification.html.erb",
    "app/views/user_mailer/welcome_notification.hu.html.erb",
    "app/views/user_mailer/welcome_notification.id.html.erb",
    "app/views/user_mailer/welcome_notification.it.html.erb",
    "app/views/user_mailer/welcome_notification.iw.html.erb",
    "app/views/user_mailer/welcome_notification.ja.html.erb",
    "app/views/user_mailer/welcome_notification.ko.html.erb",
    "app/views/user_mailer/welcome_notification.lt.html.erb",
    "app/views/user_mailer/welcome_notification.lv.html.erb",
    "app/views/user_mailer/welcome_notification.mt.html.erb",
    "app/views/user_mailer/welcome_notification.nl.html.erb",
    "app/views/user_mailer/welcome_notification.no.html.erb",
    "app/views/user_mailer/welcome_notification.pl.html.erb",
    "app/views/user_mailer/welcome_notification.pt-PT.html.erb",
    "app/views/user_mailer/welcome_notification.ro.html.erb",
    "app/views/user_mailer/welcome_notification.ru.html.erb",
    "app/views/user_mailer/welcome_notification.sk.html.erb",
    "app/views/user_mailer/welcome_notification.sl.html.erb",
    "app/views/user_mailer/welcome_notification.sq.html.erb",
    "app/views/user_mailer/welcome_notification.sr.html.erb",
    "app/views/user_mailer/welcome_notification.sv.html.erb",
    "app/views/user_mailer/welcome_notification.text.erb",
    "app/views/user_mailer/welcome_notification.th.html.erb",
    "app/views/user_mailer/welcome_notification.tl.html.erb",
    "app/views/user_mailer/welcome_notification.tr.html.erb",
    "app/views/user_mailer/welcome_notification.uk.html.erb",
    "app/views/user_mailer/welcome_notification.vi.html.erb",
    "app/views/user_mailer/welcome_notification.zh-CN.html.erb",
    "app/views/user_mailer/welcome_notification.zh-TW.html.erb",
    "app/views/user_mailer/welcome_notification.zh.html.erb",
    "app/views/user_sessions/_form.erb",
    "app/views/user_sessions/new.html.erb",
    "app/views/username_request/new.html.erb",
    "app/views/users/_available.html.erb",
    "app/views/users/_recover_password_via_email_link.html.erb",
    "app/views/users/_signup_form.html.erb",
    "app/views/users/_signup_form_javascript.html.erb",
    "app/views/users/_unavailable.html.erb",
    "app/views/users/_user.html.erb",
    "app/views/users/activation_confirmation.html.erb",
    "app/views/users/activation_instructions.html.erb",
    "app/views/users/edit.html.erb",
    "app/views/users/new.html.erb",
    "app/views/users/show.html.erb",
    "app/views/users/welcome.html.erb",
    "config/locales/ar.yml",
    "config/locales/bg.yml",
    "config/locales/ca.yml",
    "config/locales/cs.yml",
    "config/locales/da.yml",
    "config/locales/de.yml",
    "config/locales/el.yml",
    "config/locales/en.yml",
    "config/locales/es.yml",
    "config/locales/et.yml",
    "config/locales/fa.yml",
    "config/locales/fi.yml",
    "config/locales/fr.yml",
    "config/locales/gl.yml",
    "config/locales/hi.yml",
    "config/locales/hr.yml",
    "config/locales/ht.yml",
    "config/locales/hu.yml",
    "config/locales/id.yml",
    "config/locales/it.yml",
    "config/locales/iw.yml",
    "config/locales/ja.yml",
    "config/locales/ko.yml",
    "config/locales/lt.yml",
    "config/locales/lv.yml",
    "config/locales/mt.yml",
    "config/locales/nl.yml",
    "config/locales/no.yml",
    "config/locales/pl.yml",
    "config/locales/pt-PT.yml",
    "config/locales/ro.yml",
    "config/locales/ru.yml",
    "config/locales/sk.yml",
    "config/locales/sl.yml",
    "config/locales/sq.yml",
    "config/locales/sr.yml",
    "config/locales/sv.yml",
    "config/locales/th.yml",
    "config/locales/tl.yml",
    "config/locales/tr.yml",
    "config/locales/uk.yml",
    "config/locales/vi.yml",
    "config/locales/zh-CN.yml",
    "config/locales/zh-TW.yml",
    "config/locales/zh.yml",
    "config/routes.rb",
    "db/migrate/20090320174818_create_muck_permissions_and_roles.rb",
    "db/migrate/20090327231918_create_users.rb",
    "db/migrate/20100123035450_create_access_codes.rb",
    "db/migrate/20100123233654_create_access_code_requests.rb",
    "db/migrate/20101117172951_add_name_to_access_code_requests.rb",
    "db/migrate/20110303183433_add_sent_to_to_access_codes.rb",
    "lib/muck-users.rb",
    "lib/muck-users/config.rb",
    "lib/muck-users/controllers/authentic_application.rb",
    "lib/muck-users/engine.rb",
    "lib/muck-users/exceptions.rb",
    "lib/muck-users/form_builder.rb",
    "lib/muck-users/mailers/user_mailer.rb",
    "lib/muck-users/models/access_code.rb",
    "lib/muck-users/models/access_code_request.rb",
    "lib/muck-users/models/user.rb",
    "lib/muck-users/secure_methods.rb",
    "lib/tasks/muck_users.rake",
    "muck-users.gemspec",
    "public/images/admin/roles.gif",
    "public/images/admin/source/User.png",
    "public/images/admin/source/roles.png",
    "public/images/admin/user.gif",
    "public/images/icon_no.gif",
    "public/images/icon_success.gif",
    "public/images/profile_default.jpg",
    "public/javascripts/muck-users.js",
    "public/stylesheets/muck-users.css"
  ]
  s.homepage = %q{http://github.com/jbasdf/muck_users}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.0}
  s.summary = %q{Easy to use user engine for Rails}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<authlogic>, [">= 0"])
      s.add_runtime_dependency(%q<bcrypt-ruby>, [">= 0"])
      s.add_runtime_dependency(%q<muck-engine>, [">= 3.0.3"])
      s.add_runtime_dependency(%q<friendly_id>, [">= 0"])
    else
      s.add_dependency(%q<authlogic>, [">= 0"])
      s.add_dependency(%q<bcrypt-ruby>, [">= 0"])
      s.add_dependency(%q<muck-engine>, [">= 3.0.3"])
      s.add_dependency(%q<friendly_id>, [">= 0"])
    end
  else
    s.add_dependency(%q<authlogic>, [">= 0"])
    s.add_dependency(%q<bcrypt-ruby>, [">= 0"])
    s.add_dependency(%q<muck-engine>, [">= 3.0.3"])
    s.add_dependency(%q<friendly_id>, [">= 0"])
  end
end

