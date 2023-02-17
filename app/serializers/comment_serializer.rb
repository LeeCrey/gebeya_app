# frozen_string_literal: true

class CommentSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_date

  belongs_to :customer

  def created_date
    object.created_at.to_date.to_s
  end
end
