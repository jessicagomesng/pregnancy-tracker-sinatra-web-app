# users_list = [
#     { :username => "peternicusisking", :email => "peety@gmail.com", :password => "Hello123" },
#     { :username => "icecream23", :email => "vanillaisgod@gmail.com", :password => "HotFudg3"}, 
#     { :username => "poopiemagoopie", :email => "poopie@gmail.com", :password => "PoopsMag00ps"}]

# users_list.each do |user_hash|
#   u = User.new(user_hash)
#   u.save
# end

# message_list = {
#     "Hi! I'm new to this!" => {
#     },
#     "I like ice cream" => {
#     },
#     "Be my friend?" => {
#     },
#     "Sooo tired" => { 
#     }
#   }

# message_list.each do |content, message_hash|
#   m = Message.new
#   m.content = content
#   m.save
# end

# entry_list = {
#     "2020-06-01" => { :temperature => 37.01, :weight => 47.00, :weeks => 2, :notes => "", :to_dos => "see doctor"
#     },
#     "2020-06-20" => { :temperature => 36.63, :weight => 58.00, :weeks => 12, :notes => "went for a run", :to_dos => "buy pram"
#     },
#     "2020-05-10" => { :temperature => 36.40, :weight => 80.00, :weeks => 30, :notes => "ultrasound", :to_dos => "groceries"
#     }
#   }

# entry_list.each do |date, entry_hash|
#   e = Entry.new
#   e.date = date
#   e.save
# end


symptom_list = [
  "mood swings", 
  "cramps", 
  "fatigue", 
  "headache", 
  "acne", 
  "flush", 
  "dizziness", 
  "tinnitus", 
  "bitter taste", 
  "breast pain", 
  "backache", 
  "bloating", 
  "ovulation pain", 
  "frequent urination", 
  "increased appetite", 
  "inappetence", 
  "nausea", 
  "indigestion", 
  "vomiting", 
  "heartburn", 
  "constipation", 
  "diarrhea", 
  "gas", 
  "stomach ache", 
  "heightened sense of smell"
] 

symptom_list.each do |symptom_name|
  s = Symptom.new
  s.name = symptom_name 
  s.save 
end 