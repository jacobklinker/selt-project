class UserMailer < ApplicationMailer
    default from: "Pick_'Em@NOREPLY.com"
    
    def test_email()
        mail(to: "tyler-parker@uiowa.edu", subject: "Please work")
    end
    
    def league_invite(user)
        @user=user
        mail(to: @user, subject: "You're Invited!")
    end
end
