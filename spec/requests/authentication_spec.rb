require 'rails_helper'

RSpec.describe 'Token Authorization' do
  describe 'GET /token_auth' do
    let(:test_token)  { 'ifhfaeufh87ghdu3' }

    context 'with a valid token when no user exists yet' do
      let(:google_test_payload) { 
        {
          name: Faker::Name.name,
          email: Faker::Internet.email,
          google_token: test_token
        }
      }

      before :each do 
        allow(GoogleService).to receive(:decode).and_return(google_test_payload)
        get '/token_auth', params: {
          auth_token: test_token
        }
      end

      it 'returns status 200' do
        expect(response).to have_http_status 200
      end

      it 'contains expected keys' do
        json = JSON.parse(response.body, { symbolize_names: true })

        expect(json).to have_key(:is_new)
        expect(json[:is_new]).to eq true

        expect(json).to have_key(:token)
        expect(json[:token]).to eq test_token
      end
    end

    context 'with a valid token when user exists' do
      before :each do 
        @user = create(:user)

        allow(GoogleService).to receive(:decode).and_return({
          name: @user.name,
          email: @user.email,
          google_token: @user.google_token
        })
        
        get '/token_auth', params: {
          auth_token: @user.google_token
        }
      end

      it 'returns status 200' do
        expect(response).to have_http_status 200
      end

      it 'contains expected keys' do
        json = JSON.parse(response.body, { symbolize_names: true })

        expect(json).to have_key(:is_new)
        expect(json[:is_new]).to eq false

        expect(json).to have_key(:token)
        expect(json[:token]).to eq @user.google_token
      end
    end

    context 'with an invalid token' do
      before :each do 
        allow(GoogleService).to receive(:decode).and_return({
          error: "invalid_token", 
          error_description: "Invalid Value"
        })
        
        get '/token_auth', params: {
          auth_token: 'some terribly wrong invalid token'
        }
      end

      it 'returns status 400' do
        expect(response).to have_http_status 400
      end

      it 'contains expected keys' do
        json = JSON.parse(response.body, { symbolize_names: true })

        expect(json).to have_key(:error)
        expect(json[:error]).to eq 'invalid_token'

        expect(json).to have_key(:error_description)
        expect(json[:error_description]).to eq 'Invalid Value'
      end
    end
  end
end
