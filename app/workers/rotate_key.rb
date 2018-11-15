class RotateKey
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  sidekiq_options retry: 5

  def perform
    # 1. Key Rotation to new key
    new_key = DataEncryptingKey.generate!
    rotate_with_key(new_key)

    # 2. Re-encryption with new key
    EncryptedString.all.each do |string|
      string.reencrypt!(new_key)
    end

    # 3. Deleting any unused keys
    DataEncryptingKey.unused.each(&:destroy)
  end

  def rotate_with_key(new_key)
    ActiveRecord::Base.transaction do
      old_keys = DataEncryptingKey.all
      old_keys.each do |key|
        key.make_non_primary
      end
      new_key.update_attribute(:primary, true)
    end
  end

end
