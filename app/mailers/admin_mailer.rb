class AdminMailer < ApplicationMailer
  def contact_user(user, subject, message)
    @user    = user
    @message = message
    mail(to: @user.email, subject: subject)
  end

  def introduce_users(user1, user2, message)
    @user1   = user1
    @user2   = user2
    @message = message
    mail(
      to:      [@user1.email, @user2.email],
      subject: "SkillSwap vous met en relation : #{@user1.name} ↔ #{@user2.name}"
    )
  end
end
