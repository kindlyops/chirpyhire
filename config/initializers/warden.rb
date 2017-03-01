Warden::Manager.after_set_user do |account, auth, opts|
  scope = opts[:scope]

  auth.cookies.signed["#{scope}_id"] = account.id
  auth.cookies.signed["#{scope}_expires_at"] = 30.minutes.from_now
end

Warden::Manager.before_logout do |_account, auth, opts|
  scope = opts[:scope]

  auth.cookies.signed["#{scope}_id"] = nil
  auth.cookies.signed["#{scope}_expires_at"] = nil
end
