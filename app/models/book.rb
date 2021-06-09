class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true, length: {maximum: 200}

  ransacker :created_at, type: :date do
    Arel.sql('date(created_at)')
  end

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
end
