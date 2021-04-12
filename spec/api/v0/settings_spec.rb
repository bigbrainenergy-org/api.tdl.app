require 'swagger_helper'

RSpec.describe 'Settings' do
  let(:user) { create :user }

  path '/username' do
    get 'Retrieves a user\'s username' do
      produces 'application/json'

      response '200', 'Success' do
        let(:user_session) { create :user_session, user: user }
        let(:token) do
          # This is dumb and jank, fix it.
          UserSessionsController.new.issue_jwt_token(
            { user_session_id: user_session.id.to_s }
          )
        end
        let(:Authorization) { "Bearer #{token}" }

        run_test!
      end

      response '401', 'Not authorized' do
        let(:Authorization) { nil }

        run_test!
      end
    end
  end
end
