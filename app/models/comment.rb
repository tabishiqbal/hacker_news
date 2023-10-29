class Comment < ApplicationRecord
  belongs_to :story

  validates :hn_id, presence: true
  validates :body, presence: true
end
