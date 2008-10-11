Factory.sequence :title do |n|
  "Some Title #{n}"
end

Factory.sequence :login do |n|
  "JohnDoe#{n}"
end

Factory.sequence :email do |n|
  "john.doe#{n}@example.com"
end