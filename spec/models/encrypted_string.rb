require 'rails_helper'

RSpec.describe EncryptedString, :type => :model do
	it {is_expected.to respond_to :really_long_encryption_thing_that_probably_shoud_be_renamed}
	it {is_expected.to respond_to :reencrypt!}


  describe "really_long_encryption_thing_that_probably_shoud_be_renamed" do
    it "should return valid key" do
      data_encrypting_key = FactoryGirl.create(:data_encrypting_key, primary: true, key: AES.key)
      encrypted_string = FactoryGirl.create(:encrypted_string, value: "Sample String")
      expect(encrypted_string.really_long_encryption_thing_that_probably_shoud_be_renamed).to be_truthy
      expect(encrypted_string.really_long_encryption_thing_that_probably_shoud_be_renamed).to eq(data_encrypting_key.encrypted_key)
    end
  end

  describe "reencrypt!" do
    it "should update valid value and return true" do
      data_encrypting_key = FactoryGirl.create(:data_encrypting_key, primary: false, key: AES.key)
      encrypted_string = FactoryGirl.create(:encrypted_string, value: "Sample String")
      expect(encrypted_string.data_encrypting_key).should_not eq(data_encrypting_key)
      expect(encrypted_string.reencrypt!(data_encrypting_key)).to eq(true)
    end
  end

end
