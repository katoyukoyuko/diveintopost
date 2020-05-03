class AgendasController < ApplicationController
  # before_action :set_agenda, only: %i[show edit update destroy]
  before_action :set_agenda, only: %i[destroy]

  def index
    @agendas = Agenda.all
  end

  def new
    @team = Team.friendly.find(params[:team_id])
    @agenda = Agenda.new
  end

  def create
    @agenda = current_user.agendas.build(title: params[:title])
    @agenda.team = Team.friendly.find(params[:team_id])
    current_user.keep_team_id = @agenda.team.id
    if current_user.save && @agenda.save
      redirect_to dashboard_url, notice: I18n.t('views.messages.create_agenda')
    else
      render :new
    end
  end

  def destroy # AgendasControllerのdestroyアクションを追加(issue #4)
    # Agendaを削除できるのは、そのAgendaの作者もしくはそのAgendaに紐づいているTeamの作者（オーナー）のみを追加(issue #4)
    if @agenda.team.owner == current_user || @agenda.user == current_user
      @agenda.destroy
      # Agendaが削除されると、そのAgendaに紐づいているTeamに所属しているユーザー全員に通知メールが飛ぶ(issue #4)
      AgendaMailer.agenda_mail(@agenda).deliver
      redirect_to dashboard_url, notice: I18n.t('views.messages.delete_agenda')
    else
      redirect_to dashboard_url, notice: I18n.t('views.messages.cannot_delete_only_a_owner')
    end
  end

  private

  def set_agenda
    @agenda = Agenda.find(params[:id])
  end

  def agenda_params
    params.fetch(:agenda, {}).permit %i[title description]
  end
end
