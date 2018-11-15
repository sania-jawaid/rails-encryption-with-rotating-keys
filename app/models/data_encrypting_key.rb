class DataEncryptingKey < ActiveRecord::Base

  attr_encrypted :key,
                 key: :key_encrypting_key

  validates :key, presence: true

  scope :non_primary_keys, -> { where("data_encrypting_keys.primary = false or data_encrypting_keys.primary is NULL") }

  def self.unused
    DataEncryptingKey.non_primary_keys.select do |key|
      EncryptedString.where(data_encrypting_key_id: key.id).none?
    end
  end

  def self.primary
    find_by(primary: true) || self.generate!
  end

  def self.generate!(attrs={})
    create!(attrs.merge(key: AES.key))
  end

  def key_encrypting_key
    ENV['KEY_ENCRYPTING_KEY']
  end

  def make_non_primary
    update_attribute(:primary, false)
  end

end
