require 'swagger_helper'

RSpec.describe 'Users' do
  let(:current_user) { create :user }
  let(:user_session) { create :user_session, user: current_user }
  let(:token) do
    # This is dumb and jank, fix it.
    UserSessionsController.new.issue_jwt_token(
      { user_session_id: user_session.id.to_s }
    )
  end
  let(:Authorization) { "Bearer #{token}" }
  let!(:other_user) { create :user }

  path '/users/{id}' do
    parameter name: :id, in: :path, type: :string

    let(:id) { current_user.id }

    get 'Show user' do
      tags 'Users'
      description 'Returns the information for a specific user.'
      produces 'application/json'

      response '200', 'Success' do
        schema({ '$ref' => '#/components/schemas/User'})

        run_test!
      end

      response '401', 'Access token is missing or invalid' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:Authorization) { nil }

        run_test!
      end

      response '403', 'You don\'t have permission to do that' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:id) { other_user.id }

        run_test!
      end

      response '404', 'The specified resource was not found' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:id) { 1337 }

        run_test!
      end
    end

    patch 'Update user' do
      tags 'Users'
      description 'Update an existing user.'

      parameter name: :user, in: :body, schema: {
        '$ref' => '#/components/schemas/User'
      }
      consumes 'application/json'

      let(:user) { { locale: 'ja' } }

      response '200', 'Success' do
        run_test!
      end

      response '400', 'Missing parameters' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:user) { nil }

        run_test!
      end

      response '401', 'Not authenticated' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:Authorization) { nil }

        run_test!
      end

      response '403', 'Not authorized' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:id) { other_user.id }

        run_test!
      end

      response '404', 'Not Found' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:id) { 1337 }

        run_test!
      end

      response '422', 'Failed to process user' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:user) { { locale: nil } }

        run_test!
      end
    end
  end
end
