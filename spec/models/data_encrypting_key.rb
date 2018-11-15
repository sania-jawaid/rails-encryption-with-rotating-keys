require 'rails_helper'

RSpec.describe DataEncryptingKey, :type => :model do
	it {is_expected.to respond_to :key_encrypting_key}
	it {is_expected.to respond_to :make_non_primary}

  describe "non_primary_keys" do
    it "should return non_primary_keys" do
      data_encrypting_key = FactoryGirl.create(:data_encrypting_key, primary: false, key: AES.key)
      expect(DataEncryptingKey.non_primary_keys).to include(data_encrypting_key)
    end
  end

  describe "unused" do
    it "should return non_primary_keys" do
      data_encrypting_key1 = FactoryGirl.create(:data_encrypting_key, primary: true, key: AES.key)
      data_encrypting_key2 = FactoryGirl.create(:data_encrypting_key, primary: false, key: AES.key)
      encrypted_string = FactoryGirl.create(:encrypted_string, value: "Sample String")
      expect(DataEncryptingKey.unused).to include(data_encrypting_key2)
    end
  end

  describe "generate" do
    it "should create data_encrypting_key and return true" do
      expect(DataEncryptingKey.generate!({primary: false})).to be_truthy
    end
  end

  describe "key_encrypting_key" do
    it "should return valid key" do
      data_encrypting_key = FactoryGirl.create(:data_encrypting_key, primary: true, key: AES.key)
      expect(data_encrypting_key.key_encrypting_key).to be_truthy
    end
  end

  describe "make_non_primary" do
    it "should update valid value and return true" do
      data_encrypting_key = FactoryGirl.create(:data_encrypting_key, primary: true, key: AES.key)
      expect(data_encrypting_key.make_non_primary).to eq(true)
      expect(data_encrypting_key.primary).to eq(false)
    end
  end

end
