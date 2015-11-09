require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  
    it "should send a test email to tp" do
        email = UserMailer.test_email
        expect(email.to).to eq(["tyler-parker@uiowa.edu"])
        expect(email.subject).to eq("Please work")
    end
    
    it "should send an email to a user inviting them to a league" do
        user = double(User)
        expect(user).to receive(:email).and_return("jklinker1@gmail.com")
        email = UserMailer.league_invite(user)
        expect(email.to).to eq(['jklinker1@gmail.com'])
        expect(email.subject).to eq("You're Invited!")
    end
      
end
