class UserMailer < ApplicationMailer
    default from: "Pick_'Em@NOREPLY.com"
    
    def test_email
        mail(to: "tyler-parker@uiowa.edu", subject: "Please work")
    end
    
    def league_invite(user,league_id)
        @user=user
        #@url=url
        @league_id = league_id
<<<<<<< HEAD
        mail(to: @user, subject: "You're Invited!")
=======
        mail(to: @user.email, subject: "You're Invited!")
>>>>>>> 1489ddc6b4d39ed60fa0b3feebfa015b63088217
    end
end
