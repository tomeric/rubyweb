Factory.define :user do |u|
  u.login { Factory.next :login }
  u.email { Factory.next :email }
  u.password 'password'
  u.password_confirmation 'password'
end

Factory.define :admin, :class => User do |a|
  a.login { Factory.next :login }
  a.email { Factory.next :email }
  a.password 'password'
  a.password_confirmation 'password'
  a.admin true
end