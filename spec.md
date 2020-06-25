# Specifications for the Sinatra Assessment

Specs:
- [x] Use Sinatra to build the app - I'm inheriting from Sinatra::Base on my main Application Controller. 
- [x] Use ActiveRecord for storing information in a database - I inherited from ActiveRecord::Migration for my migrations and ActiveRecord::Base for my classes. I used the methods available to me thanks to ActiveRecord to set up associations between my models and to store information.
- [x] Include more than one model class (e.g. User, Post, Category) - I have several models, including User, Entry, Message, and Symptom.
- [x] Include at least one has_many relationship on your User model (e.g. User has_many Posts) - a User has many Messages.
- [x] Include at least one belongs_to relationship on another model (e.g. Post belongs_to User) - a Message belongs to a user.
- [x] Include user accounts with unique login attribute (username or email) - I check for unique attributes in my '/signup' route. I use password validation thanks to the 'bcrypt' gem so that authentication can be done in a secure way.
- [x] Ensure that the belongs_to resource has routes for Creating, Reading, Updating and Destroying - these routes are available to both entries and messages.
- [x] Ensure that users can't modify content created by other users - I have written tests and implemented conditions to make sure that a user can only edit/delete his/her content.
- [x] Include user input validations - I have used regex expressions to validate user input. I have also included conditions to ensure blank entries/messages cannot be created.
- [x] BONUS - not required - Display validation failures to user with error message (example form URL e.g. /posts/new) - I've added in flash messages that display when something fails (or when it succeeds).
- [x] Your README.md includes a short description, install instructions, a contributors guide and a link to the license for your code

Confirm
- [x] You have a large number of small Git commits - I did not commit nearly as much as I should have. I honestly completely forgot about committing because I was working on my local environment; this is definitely something that needs improvement!!
- [x] Your commit messages are meaningful - I did try and make meaningful commits!
- [x] You made the changes in a commit that relate to the commit message
- [x] You don't include changes in a commit that aren't related to the commit message - I honestly think this section needs a lot of work as I really didn't commit nearly as often as I should have. 
