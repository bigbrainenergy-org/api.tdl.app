require 'swagger_helper'

RSpec.describe 'Authentication' do
  let(:user) { create :user, password: 'correcthorsebatterystaple' }

  path '/login' do
    post 'Creates a session token' do
      tags 'Authentication'
      description 'Takes login credentials, and returns a JWT session token if successful.'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :login, in: :body, schema: {
        '$ref' => '#/components/schemas/Login'
      }
      security []

      response '200', 'Logged in successfully' do
        schema({ '$ref' => '#/components/schemas/SessionToken'})

        let(:login) do
          { username: user.username, password: 'correcthorsebatterystaple' }
        end

        run_test!
      end

      response '400', 'Invalid params' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:login) { nil }

        run_test!
      end

      response '400', 'Failed to login' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:login) { { username: user.username, password: 'wrong' } }

        run_test!
      end
    end
  end

  path '/verify/token' do
    post 'Verifies 2FA via hardware token' do
      tags 'Authentication'
      description '2FA verification using a hardware token.'
      produces 'application/json'
      security []

      response '501', 'Not implemented yet' do
        schema({ '$ref' => '#/components/schemas/Error'})

        run_test!
      end
    end
  end

  path '/verify/app' do
    post 'Verifies 2FA via authy app' do
      tags 'Authentication'
      description '2FA verification using an authy app.'
      produces 'application/json'
      security []

      response '501', 'Not implemented yet' do
        schema({ '$ref' => '#/components/schemas/Error'})

        run_test!
      end
    end
  end

  path '/logout' do
    delete 'Destroys a session token' do
      tags 'Authentication'
      description 'Logs out your current session by revoking the JWT token server-side.'
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
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:Authorization) { nil }

        run_test!
      end
    end
  end
end
