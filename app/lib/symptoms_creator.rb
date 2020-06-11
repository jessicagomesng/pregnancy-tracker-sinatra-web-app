#move this folder
#have a hash of symptoms 
class SymptomsCreator 

    @@symptoms_array = [
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

    def self.call 
        if Symptom.all.length == 0 
            @@symptoms_array.each do |symptom|
                Symptom.create(:name => symptom)
            end 
        end 
    end 
end 
#create new objects of symptoms -- but only if these symptoms are not already in the DB from last login. 
#there are preexisting symptoms a user can select from
#or a user can create a new symptom, which gets displayed only to the user. 
