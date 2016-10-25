# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

10.times do
  s = Statement.create(content: Faker::Lorem.sentence)
  i = Individual.create(name: Faker::Name.name, bio: Faker::Lorem.sentence)
  Agreement.create(statement: s, individual: i, extent: 100, reason: Faker::Lorem.sentence, url: Faker::Internet.url)
end
