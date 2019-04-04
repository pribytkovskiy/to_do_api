class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :name

  has_many(:tasks) { object.tasks.order(:position) }
  belongs_to :user

  link(:self) { api_v1_project_url(object) }
end
