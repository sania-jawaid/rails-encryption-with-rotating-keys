require 'rails_helper'

RSpec.describe "LoadTestStringsAndEncryptUsingRotatingKeys", type: :request do

  before (:all) do
    (1..1001).each do |i|
      encrypted_string = FactoryGirl.create(:encrypted_string, value: "Sample String #{i}")
    end
  end

  describe "CREATE encrypted_string" do
    it "should create and encrypt the strings and return tokens with valid params" do
      post encrypted_strings_path(encrypted_string: {value: "Test Sample String"})
      assert_response :success
      assert_predicate JSON.parse(response.body)['token'], :present?
    end
  end

  describe "GET encrypted_string" do
    it "returns decrypted string with valid token" do
      encrypted_string = FactoryGirl.create(:encrypted_string, value: "Sample String")
      get encrypted_string_path(encrypted_string.token)
      assert_response :success
      assert_equal JSON.parse(response.body)["value"], encrypted_string.value
    end
  end

  describe "Queueing rotation Job" do
    it "should enqueue the worker for rotating the key when run for the first time" do
      post data_encrypting_keys_rotate_path
      assert_response :success
      assert_equal JSON.parse(response.body)["message"], "Successfully started Rotation Job"
      puts "Response of Rotating #{response.body}"
    end

    it "should enqueue the worker for rotating the key when run for the second time" do
      post data_encrypting_keys_rotate_path
      assert_response :forbidden
      assert JSON.parse(response.body)["message"].include?("Cannot start new job")
      puts "Response of Enqeuing second time #{response.body}"
    end
  end

  describe "Polling rotation Job" do
    it "returns the status of the job" do
      loop do
        get data_encrypting_keys_rotate_status_path
        assert_response :success
        response_message = JSON.parse(response.body)["message"]
        assert_predicate response_message, :present?
        puts "Response of Polling #{response.body}"
        break if response_message == "Current Job is Complete"
      end
    end
  end

end
