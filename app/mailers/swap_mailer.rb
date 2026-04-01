class SwapMailer < ApplicationMailer
  def welcome(user)
    @user = user
    mail(to: @user.email, subject: "Bienvenue sur SkillSwap ! 🎉")
  end

  def swap_proposed(swap)
    @swap     = swap
    @proposer = swap.proposer
    @receiver = swap.receiver
    @skill    = swap.skill
    mail(to: @receiver.email,
         subject: "#{@proposer.name} vous propose un swap : #{@skill.name}")
  end

  def swap_accepted(swap)
    @swap     = swap
    @proposer = swap.proposer
    @receiver = swap.receiver
    @skill    = swap.skill
    mail(to: @proposer.email,
         subject: "#{@receiver.name} a accepté votre swap ✓")
  end
end
