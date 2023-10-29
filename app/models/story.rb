class Story < ApplicationRecord
  has_many :comments, dependent: :destroy

  validates :title, presence: true
  validates :hn_id, presence: true, uniqueness: true
end
