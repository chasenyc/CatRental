class Cat < ActiveRecord::Base
  validates :birth_date, :color, :name, :sex, presence: true
  validates :sex, inclusion: { in: %w(M F), message: "%{value} is not a gender"}

  def age
    ((Time.now - birth_date.to_time) / 1.year).floor
  end

  

end
