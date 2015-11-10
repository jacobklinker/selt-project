require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  
    it "should send a test email to tp" do
        email = UserMailer.test_email
        expect(email.to).to eq(["tyler-parker@uiowa.edu"])
        expect(email.subject).to eq("Please work")
    end
    
    it "should send an email to a user inviting them to a league" do
        user = double(User)
        email = UserMailer.league_invite("jklinker1@gmail.com",1)
        expect(email.to).to eq(['jklinker1@gmail.com'])
        expect(email.subject).to eq("You're Invited!")
    end
      
end
