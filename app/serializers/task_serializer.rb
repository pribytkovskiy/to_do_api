class TaskSerializer < ActiveModel::Serializer
  attributes :id, :name, :deadline, :position, :completed, :comments_count

  belongs_to :project
  has_many :comments

  def comments_count
    object.comments.count
  end

  link(:self) { api_v1_task_url(object) }
end
