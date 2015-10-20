class CatRentalRequest < ActiveRecord::Base
  validates :cat_id, :start_date, :end_date, :status, presence: true
  validates :status, inclusion: { in: %w(PENDING APPROVED DENIED), message: "%{value} is not a status"}
  validate :any_overlapping_requests?


  belongs_to :cat,
    class_name: 'Cat',
    foreign_key: :cat_id,
    primary_key: :id


  def overlapping_requests
    # !(self.end_date < rental.start_date || rental.end_date < self.start_date)
    result = CatRentalRequest
      .where("start_date > ? OR end_date < ?", self.end_date, self.start_date)

    if self.persisted?
      result = result.where("id != ?", self.id)
    end

    result
  end

  def overlapping_approved_requests
    overlapping_requests.where(status: "APPROVED")
  end

  def any_overlapping_requests?
    unless overlapping_approved_requests
      errors.add(:cat_rental_request, "cannot overlap approved requests")
    end
  end

  def overlapping_pending_requests
    overlapping_requests.where(status: "PENDING")
  end

  def approve!
    self.transaction do
      if self.pending?
        self.update!(status: 'APPROVED')
        overlapping_pending_requests.each(&:deny!)
      end
    end
  end

  def deny!
    self.status = "DENIED"
  end

  def pending?
    self.status == 'PENDING'
  end

end
