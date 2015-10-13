class Campaign < ActiveRecord::Base

  validates :external_id, presence: true
  scope :for_publish, -> { where(need_to_upload: true) }


  def merge(data)
    change_attributes(data)
    self[:data] = self[:data].merge(data[:data])
  end

  def reverse_merge(data)
    change_attributes(data)
    self[:data] = self[:data].reverse_merge(data[:all_attributes])
  end

  def changed_to_hash
    self[:data].slice(*self[:dirty_attributes])
  end

  private

  def change_attributes(data)
    self[:need_to_upload] = true
    self[:dirty_attributes] = self[:dirty_attributes] | data[:dirty_attributes]
  end

end
