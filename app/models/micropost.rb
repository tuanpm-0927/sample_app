class Micropost < ApplicationRecord
  belongs_to :user
  scope :feed, ->(id){where "user_id = ?", id}
  scope :order_by, ->{order created_at: :desc}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.validates.maximum_content}
  validate :picture_size

  private
  def picture_size
    return unless picture.size > Settings.micropost.img_size.megabytes
    errors.add(:picture, I18n.t(".less_5mb"))
  end
end
