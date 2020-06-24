require 'spec_helper'

describe EntriesController do 
    
    describe "Entries" do 
        it "shows a list of only the user's entries if logged in" do 
            user1 = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")
            entry1 = Entry.create(:date => 2020-14-06, :weeks => 5, :notes => "testing", :user_id => user1.id)
            
            user2 = User.create(:username => "lovemyweasel", :email => "scraphoundsunite@gmail.com", :password => "PeetboBeet123")
            entry2 = Entry.create(:date => 2020-19-06, :weeks => 3, :notes => "my mom is pregnant! woof!", :user_id => user2.id)

            visit '/login'
            fill_in(:username, :with => "hotdoggy")
            fill_in(:password, :with => "ImaPup45")
            click_button 'Log In'
            visit "/entries"

            expect(page).to have_selector(:css, 'a[href="entries/1"]')
            expect(page).to_not have_selector(:css, 'a[href="entries/2"]')
        end 

        it 'does not entries if not logged in' do 
            visit '/entries'
            expect(page.current_path).to include('/login')
            expect(page).to have_content("You must be logged in to do that!")
        end 
    end 

    describe "Entry Show Page" do
        context 'logged in' do 
            it 'displays a single entry' do 
                user = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")
                entry = Entry.create(:date => 2020-14-06, :weeks => 5, :notes => "testing this bad boy out", :user_id => user.id)

                visit '/login'
                fill_in(:username, :with => "hotdoggy") 
                fill_in(:password, :with => "ImaPup45")
                click_button 'Log In'

                visit "/entries/#{entry.id}"
                expect(page.status_code).to eq(200)
                expect(page.body).to include(entry.notes)
                expect(page.body).to include("Edit or Delete Entry")
            end 

            it "does not allow user to access anyone else's entries" do 
                user1 = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")
                entry1 = Entry.create(:date => 2020-14-06, :weeks => 5, :notes => "testing", :user_id => user1.id)
                
                user2 = User.create(:username => "lovemyweasel", :email => "scraphoundsunite@gmail.com", :password => "PeetboBeet123")
                entry2 = Entry.create(:date => 2020-19-06, :weeks => 3, :notes => "my mom is pregnant! woof!", :user_id => user2.id)
    
                visit '/login'
                fill_in(:username, :with => "hotdoggy")
                fill_in(:password, :with => "ImaPup45")
                click_button 'Log In'
                visit "/entries/#{entry2.id}"

                expect(page.current_path).to eq("/account")
                expect(page).to have_content("Sorry, you do not have permissions to do that.")
            end 
        end 
        
        context 'logged out' do 
            it 'does not display entry' do 
                visit '/entries/1'
                expect(page.current_path).to include('/login')
                expect(page).to have_content("You must be logged in to do that!")
            end 
        end 
    end
    
    describe "New Entry" do 
        context 'logged in' do 
            it 'displays new entry form' do 
                user = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")
               
                visit '/login'
                fill_in(:username, :with => "hotdoggy") 
                fill_in(:password, :with => "ImaPup45")
                click_button 'Log In'

                visit "/entries/new"
                expect(page.status_code).to eq(200)
                expect(page.body).to include("New Entry:")
            end 

            it 'lets a user create a new entry' do 
                user = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")

                visit '/login'
                fill_in(:username, :with => "hotdoggy") 
                fill_in(:password, :with => "ImaPup45")
                click_button 'Log In'

                visit '/entries/new'
                fill_in(:weeks, :with => 4)
                fill_in(:date, :with => 2020-16-04)
                fill_in(:notes, :with => "This is my new entry")
                click_button "Create New Entry"

                entry = Entry.find_by(:notes => "This is my new entry")
                expect(entry).to be_instance_of(Entry)
                expect(entry.user_id).to eq(user.id)
                expect(page.status_code).to eq(200)
                expect(page).to have_content("Entry created.")
            end 

            it 'does not let a user create an entry without a date' do 
                user = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")

                visit '/login'
                fill_in(:username, :with => "hotdoggy") 
                fill_in(:password, :with => "ImaPup45")
                click_button 'Log In'

                visit '/entries/new'
                fill_in(:weeks, :with => 5)
                fill_in(:notes, :with => "This is my new entry")
                click_button "Create New Entry"

                expect(Entry.find_by(:notes =>"This is my new entry")).to be(nil)
                expect(page.current_path).to eq("/entries/new")
                expect(page).to have_content("You must include a date and how many weeks you are!")
            end 

            it 'does not let a user create an entry without weeks' do 
                user = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")

                visit '/login'
                fill_in(:username, :with => "hotdoggy") 
                fill_in(:password, :with => "ImaPup45")
                click_button 'Log In'

                visit '/entries/new'
                fill_in(:date, :with => 2020-16-04)
                fill_in(:notes, :with => "This is my new entry")
                click_button "Create New Entry"

                expect(Entry.find_by(:notes =>"This is my new entry")).to be(nil)
                expect(page.current_path).to eq("/entries/new")
                expect(page).to have_content("You must include a date and how many weeks you are!")
            end 

            it 'does not let a user create a symptom that already exists' do 
                user = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")
                Symptom.create(:name => "gas")

                visit '/login'
                fill_in(:username, :with => "hotdoggy") 
                fill_in(:password, :with => "ImaPup45")
                click_button 'Log In'

                visit '/entries/new'
                fill_in(:date, :with => 2020-16-04)
                fill_in(:weeks, :with => 4)
                fill_in(:new_symptom, :with => "Gas")
                fill_in(:notes, :with => "Hi there! I'm pregnant!")
                click_button "Create New Entry"

                entry = Entry.find_by(:notes => "Hi there! I'm pregnant!")
                expect(Symptom.all.length).to eq(1)
                expect(page).to have_content("Sorry, you cannot add an existing symptom to the database. To add that symptom, simply edit your entry and select the appropriate symptom.")
                expect(page.current_path).to eq("/entries/#{entry.id}")
            end 
        end 

        context 'logged out' do
            it 'does not let user view new entry form' do 
                visit '/entries/new' 
                expect(page.current_path).to include('/login')
                expect(page).to have_content("You must be logged in to do that!")
            end 
        end 
    end 

    describe "Edit Entry" do 
        context 'logged in' do 
            it 'loads edit entry form if logged in' do 
                user = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")
                entry = Entry.create(:date => 2020-14-06, :weeks => 5, :notes => "testing this bad boy out", :user_id => user.id)

                visit '/login'
                fill_in(:username, :with => "hotdoggy") 
                fill_in(:password, :with => "ImaPup45")
                click_button 'Log In'

                visit "/entries/#{entry.id}/edit"
                expect(page.status_code).to eq(200)
                expect(page.body).to include(entry.notes)
            end 

            it "does not let user edit anyone else's entry" do 
                user1 = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")
                entry1 = Entry.create(:date => 2020-14-06, :weeks => 5, :notes => "testing", :user_id => user1.id)
                
                user2 = User.create(:username => "lovemyweasel", :email => "scraphoundsunite@gmail.com", :password => "PeetboBeet123")
                entry2 = Entry.create(:date => 2020-19-06, :weeks => 3, :notes => "my mom is pregnant! woof!", :user_id => user2.id)
    
                visit '/login'
                fill_in(:username, :with => "hotdoggy")
                fill_in(:password, :with => "ImaPup45")
                click_button 'Log In'
                visit "/entries/#{entry2.id}/edit"

                expect(page.current_path).to eq("/account")
                expect(page).to have_content("Sorry, you do not have permissions to do that.")
            end 

            it 'updates an existing entry' do 
                user = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")
                entry = Entry.create(:date => 2020-14-06, :weeks => 5, :notes => "testing this bad boy out", :user_id => user.id)

                visit '/login'
                fill_in(:username, :with => "hotdoggy") 
                fill_in(:password, :with => "ImaPup45")
                click_button 'Log In'
                visit "/entries/#{entry.id}/edit"

                fill_in(:notes, :with => "successfully edited")
                click_button "Edit Entry"

                expect(Entry.find_by(:notes =>"successfully edited")).to be_instance_of(Entry)
                expect(Entry.find_by(:notes => "testing")).to be(nil)
                expect(page.status_code).to eq(200)
                expect(page).to have_content("Entry edited.")
            end 

            it 'does not let a user edit an entry without a date' do 
                user = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")
                entry = Entry.create(:date => 2020-14-06, :weeks => 5, :notes => "testing this bad boy out", :user_id => user.id)

                visit '/login'
                fill_in(:username, :with => "hotdoggy") 
                fill_in(:password, :with => "ImaPup45")
                click_button 'Log In'
                visit "/entries/#{entry.id}/edit"

                fill_in(:date, with: "")
                fill_in(:notes, with: "successfully edited")
                click_button "Edit Entry"
                
                expect(Entry.find_by(:notes =>"successfully edited")).to be(nil)
                expect(page.current_path).to eq("/entries/#{entry.id}/edit")
                expect(page).to have_content("You must include a date and how many weeks you are!")
            end 

            it 'does not let a user edit an entry without weeks' do 
                user = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")
                entry = Entry.create(:date => 2020-14-06, :weeks => 5, :notes => "testing this bad boy out", :user_id => user.id)

                visit '/login'
                fill_in(:username, :with => "hotdoggy") 
                fill_in(:password, :with => "ImaPup45")
                click_button 'Log In'
                visit "/entries/#{entry.id}/edit"
                fill_in(:weeks, with: "")
                fill_in(:notes, with: "successfully edited")
                click_button "Edit Entry"
                
                expect(Entry.find_by(:notes =>"successfully edited")).to be(nil)
                expect(page.current_path).to eq("/entries/#{entry.id}/edit")
                expect(page).to have_content("You must include a date and how many weeks you are!")
            end 
        end 

        context 'logged out' do 
            it 'does not allow user to edit entry if not logged in' do 
                visit '/entries/1/edit'
                expect(page.current_path).to include('/login')
                expect(page).to have_content("You must be logged in to do that!")
            end 
        end 
    end 

    describe "Delete Entry" do 
        context "logged in" do 
            it 'lets a user delete own entry' do 
                user = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")
                entry = Entry.create(:date => 2020-14-06, :weeks => 5, :notes => "testing this bad boy out", :user_id => user.id)

                visit '/login'
                fill_in(:username, :with => "hotdoggy") 
                fill_in(:password, :with => "ImaPup45")
                click_button 'Log In'
                visit "/entries/#{entry.id}/edit"

                click_button "Delete Entry"

                expect(Entry.find_by(:notes => "testing this bad boy out")).to be(nil)
                expect(page.status_code).to eq(200)
                expect(page).to have_content("Entry deleted.")
            end 

            it "does not let a user delete another user's entry" do 
                user1 = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")
                entry1 = Entry.create(:date => 2020-14-06, :weeks => 5, :notes => "testing", :user_id => user1.id)
                
                user2 = User.create(:username => "lovemyweasel", :email => "scraphoundsunite@gmail.com", :password => "PeetboBeet123")
                entry2 = Entry.create(:date => 2020-19-06, :weeks => 3, :notes => "my mom is pregnant! woof!", :user_id => user2.id)
    
                visit '/login'
                fill_in(:username, :with => "hotdoggy") 
                fill_in(:password, :with => "ImaPup45")
                click_button 'Log In'
                visit "/entries/#{entry2.id}/edit"

                expect(page.current_path).to eq('/account')
            end 
        end 

        context "logged out" do 
            it 'does not let a user delete an entry if logged out' do 
                user = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")
                entry = Entry.create(:date => 2020-14-06, :weeks => 5, :notes => "testing this bad boy out", :user_id => user.id)
                visit "/entries/#{entry.id}"
                expect(page.current_path).to eq("/login")
            end 
        end 
    end 
end 