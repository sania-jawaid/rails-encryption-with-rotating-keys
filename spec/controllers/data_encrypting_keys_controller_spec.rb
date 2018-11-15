require 'rails_helper'
describe DataEncryptingKeysController, type: :controller do

  describe "response from rotate_key" do
    it "should enqueue the worker for rotating the key when run for the first time" do
      ENV['CURRENT_JOB_ID'] = nil
      post :rotate_key
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['message']).to eq("Successfully started Rotation Job")
    end

    it "should enqueue the worker for rotating the key when run for the second time" do
      post :rotate_key
      expect(response.status).to eq(403)
      expect(JSON.parse(response.body)['message']).to include("Cannot start new job")
    end
  end

  describe "response from get_current_status" do
    it "should return response of the current job" do
      get :fetch_current_status
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['message']).to be_truthy
    end
  end

end
