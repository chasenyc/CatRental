class Cat < ActiveRecord::Base
  validates :birth_date, :color, :name, :sex, presence: true
  validates :sex, inclusion: { in: %w(M F), message: "%{value} is not a gender"}

  has_many :cat_rental_requests,
    dependent: :destroy,
    class_name: 'CatRentalRequest',
    foreign_key: :cat_id,
    primary_key: :id

  def age
    ((Time.now - birth_date.to_time) / 1.year).floor
  end



end
