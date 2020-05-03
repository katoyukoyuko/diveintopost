class TeamMailer < ApplicationMailer
  default from: 'from@example.com'

  def team_mail(team)
    @team = team
    mail to: @team.owner.email, subject: "チームオーナーの権限があなたに移動しました"
  end
end
