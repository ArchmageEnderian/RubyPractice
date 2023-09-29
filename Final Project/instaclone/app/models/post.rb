class Post < ApplicationRecord
  validates :image, presence: true
  validates :description, presence: true
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one_attached :image
end
