class Cat < ActiveRecord::Base
  validates :birth_date, :color, :name, :sex, presence: true
  validates :sex, inclusion: { in: %w(M F), message: "%{value} is not a gender"}
  validate :user_exists?

  belongs_to(
    :owner,
    class_name: "User",
    foreign_key: :user_id,
    primary_key: :id
  )

  has_many :cat_rental_requests,
    dependent: :destroy,
    class_name: 'CatRentalRequest',
    foreign_key: :cat_id,
    primary_key: :id

  def age
    ((Time.now - birth_date.to_time) / 1.year).floor
  end

  def user_exists?
    user = User.find(user_id)
    if user.nil?
      errors[:cat] << "Owner needs to exist"
    end
  end

end
