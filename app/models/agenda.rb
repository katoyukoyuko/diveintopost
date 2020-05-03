class Agenda < ApplicationRecord
  belongs_to :team
  belongs_to :user
  has_many :articles, dependent: :destroy # Agendaに紐づいているarticleも一緒に削除される(dependent: :destroy すでに記載済み issue #4)
end
