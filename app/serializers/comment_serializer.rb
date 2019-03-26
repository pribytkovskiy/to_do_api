class CommentSerializer < ActiveModel::Serializer
  attributes :id, :text
  belongs_to :task

  link(:self) { api_v1_comment_url(object) }
end
