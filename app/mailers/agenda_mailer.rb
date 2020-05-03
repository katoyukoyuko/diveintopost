class AgendaMailer < ApplicationMailer
  default from: 'from@example.com'

  def agenda_mail(agenda)
    @agenda = agenda
    @members = @agenda.team.members
    @members.each do |m|
      mail to: m.email, subject: I18n.t('views.messages.delete_agenda')
    end
  end
end
