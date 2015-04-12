
tests = Test.where("name like 'Basic%'")

tests.each do |test|
tmp = test.name.split(" ") [1]
questions = Question.where("category_id in (select id from categories where lower(name) like ?)", ("%" + tmp + "%").downcase)

if !test.questions.any?
  questions.each do |question|
    test.questions << question
  end
  test.save 
end

end
