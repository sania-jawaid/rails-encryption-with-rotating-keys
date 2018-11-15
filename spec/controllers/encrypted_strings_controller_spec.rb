require 'rails_helper'
describe EncryptedStringsController, type: :controller do

  describe "response from create" do
    it "should create and encrypt the string and return a token for valid params" do
      post :create, {encrypted_string: {value: "String to be encrypted"}}
      expect(response.status).to eq(200)
      expect(response.body).to include("token")
      expect(JSON.parse(response.body)['token']).to be_truthy
    end
    it "should not create and encrypt the string and should return error response for invalid params" do
      post :create, {encrypted_string: {value: nil}}
      expect(response.status).to eq(422)
      expect(response.body).to_not include("token")
      expect(JSON.parse(response.body)['token']).to be_falsy
    end
  end

  describe "response from show" do
    it "should give decrypted string for valid token" do
      encrypted_string = FactoryGirl.create(:encrypted_string, value: "Sample String")
      get :show, token: encrypted_string.token
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['value']).to eq(encrypted_string.value)
    end

    it "should not give decrypted string for invalid token" do
      encrypted_string = FactoryGirl.create(:encrypted_string, value: "Sample String")
      get :show, token: ""
      expect(response.status).to eq(404)
      expect(JSON.parse(response.body)['value']).to eq(nil)
    end
  end

  describe "response from destroy" do
    it "should destroy encrypted string for valid token" do
      encrypted_string = FactoryGirl.create(:encrypted_string, value: "Sample String 2")
      get :destroy, token: encrypted_string.token
      expect(response.status).to eq(200)
    end

    it "should not destroy encrypted string for invalid token" do
      encrypted_string = FactoryGirl.create(:encrypted_string, value: "Sample String 2")
      get :destroy, token: ""
      expect(response.status).to eq(404)
    end
  end

end
