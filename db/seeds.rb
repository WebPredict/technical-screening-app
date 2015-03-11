# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!(name:  "Example User",
             email: "example@example.org",
             password:              "foobar",
             password_confirmation: "foobar",
              activated: true,
              activated_at: Time.zone.now)

50.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

Difficulty.create!(level: "Easy")
Difficulty.create!(level: "Medium")
Difficulty.create!(level: "Hard")

Category.create!(name: "Java")
Category.create!(name: "J2EE")
Category.create!(name: "Hibernate")
Category.create!(name: "JSP")
Category.create!(name: "Rails")
Category.create!(name: "Spring")
Category.create!(name: "Tomcat")
Category.create!(name: "SQL")
Category.create!(name: "JavaScript")
Category.create!(name: "HTML")
Category.create!(name: "Performance")
Category.create!(name: "XML")
Category.create!(name: "jQuery")
Category.create!(name: "AngularJS")
Category.create!(name: "Python")

question1 = Question.create!(content: "What types of inheritance does Java support?",
                  answer: "Java supports multiple interface inheritance, but not multiple implementation (class) inheritance. This means a class in Java can have only one base class, but has no limit on implemented interfaces (i.e. promises to provide certain functionality).",
                  user_id: 1,
                  difficulty_id: 1,
                  category_id: 1)

question2 = Question.create!(content: "Explain equals and hashcode method usage, and how they relate to each other.",
                  answer: "They must be logically in sync to ensure consistent, expected behavior when objects are used in collections and comparisons. More specifically, when two objects are considered equal, their hash codes should be the same. When they differ, their hashcodes should be different, in a consistent way.",
                  user_id: 1,
                  difficulty_id: 2,
                  category_id: 1)

test = Test.create!(name: "Basic Java Test", descrption: "This is the basic java test.", user_id: 1)
test.questions.add(question1)
test.questions.add(question2)
test.save

#users = User.order(:created_at).take(6)
#50.times do
  #content = Faker::Lorem.sentence(5)
  #users.each { |user| user.microposts.create!(content: content) }
#end

