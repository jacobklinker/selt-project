class UserMailer < ApplicationMailer
    default from: "hey@pickem.com"
    
    def test_email
        mail(to: "tyler-parker@uiowa.edu", subject: "Please work")
    end
    
    def league_invite(user,league_id)
        @user=user
        @league_id = league_id
        mail(to: @user, subject: "You're Invited!")
        #
    end
end
