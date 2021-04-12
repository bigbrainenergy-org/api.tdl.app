require 'swagger_helper'

RSpec.describe 'Authentication' do
  let(:user) { create :user, password: 'correcthorsebatterystaple' }

  path '/login' do
    post 'Creates a session token' do
      security []
      parameter name: :login, in: :body, schema: {
        '$ref' => '#/components/schemas/Login'
      }
      consumes 'application/json'

      response '200', 'Logged in successfully' do
        let(:login) do
          { username: user.username, password: 'correcthorsebatterystaple' }
        end

        run_test!
      end

      response '400', 'Invalid params' do
        let(:login) { nil }

        run_test!
      end

      response '400', 'Bad login' do
        let(:login) { { username: user.username, password: 'wrong' } }

        run_test!
      end
    end
  end

  path '/verify/token' do
    post 'Verifies 2FA via hardware token' do
      security []

      response '501', 'Not implemented yet' do
        run_test!
      end
    end
  end

  path '/verify/app' do
    post 'Verifies 2FA via authy app' do
      security []

      response '501', 'Not implemented yet' do
        run_test!
      end
    end
  end

  path '/logout' do
    delete 'Destroys a session token' do
      produces 'application/json'

      response '200', 'Logged out successfully' do
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

      response '401', 'Not authenticated' do
        let(:Authorization) { nil }

        run_test!
      end
    end
  end
end
