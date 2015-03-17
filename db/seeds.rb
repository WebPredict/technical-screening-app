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

question3 = Question.create!(content: "What is the difference between a natural key and a surrogate or synthetic key?",
                  answer: "A natural key is one in which the attributes of the key exist in the real world.  For instance, a social security number would be a natural " + 
                    "key, as it is information that exists outside of the realm of the database. A surrogate or synthetic key is a system-generated key that is arbitrary to the values in the table, yet uniquely identifies a row.  " + 
                    "For example a database administrator might set up a column in a database for employee IDs and have the DBMS generate random ID numbers to uniquely identify the employee data.",
                user_id: 1,
                difficulty_id: 3,
                category_id: 8)

question4 = Question.create!(content: "What is a join?",
                  answer: "It is a way of combining rows from two or more tables, typically using one or more common key values.",
                  user_id: 1,
                  difficulty_id: 1,
                  category_id: 8)
                
test = Test.create!(name: "Basic Java Test", description: "This is the basic java test.", user_id: 1)
test2 = Test.create!(name: "Basic SQL Test", description: "This is the basic SQL test.", user_id: 1)
test.questions << question1
test.questions << question2
test2.questions << question3
test.save
test2.save

#users = User.order(:created_at).take(6)
#50.times do
  #content = Faker::Lorem.sentence(5)
  #users.each { |user| user.microposts.create!(content: content) }
#end

