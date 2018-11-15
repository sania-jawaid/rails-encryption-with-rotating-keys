Rails.application.routes.draw do
  resources :encrypted_strings, param: :token
  post 'data_encrypting_keys/rotate' => 'data_encrypting_keys#rotate_key'
  get 'data_encrypting_keys/rotate/status' => 'data_encrypting_keys#fetch_current_status'
end
