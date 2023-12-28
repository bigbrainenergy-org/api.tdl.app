require 'swagger_helper'

RSpec.describe 'Statuses' do
  let(:user) { create :user }
  let(:user_session) { create :user_session, user: user }
  let(:token) do
    # This is dumb and jank, fix it.
    UserSessionsController.new.issue_jwt_token(
      { user_session_id: user_session.id.to_s }
    )
  end
  let(:Authorization) { "Bearer #{token}" }
  let!(:user_status) { create :status, user: user }
  let!(:other_status) { create :status }

  path '/statuses' do
    get 'Get statuses' do
      tags 'Statuses'
      description 'Returns an array of the current user\'s statuses.'
      produces 'application/json'

      response '200', 'Success' do
        schema({ '$ref' => '#/components/schemas/ArrayOfStatuses'})

        run_test!
      end

      response '401', 'Access token is missing or invalid' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:Authorization) { nil }

        run_test!
      end
    end

    post 'Create new status' do
      tags 'Statuses'
      description 'Create a new status for the current user.'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :status, in: :body, schema: {
        '$ref' => '#/components/schemas/Status'
      }, required: true

      let(:status) { { title: Faker::String.random, user: user } }

      response '200', 'Successfully created new status' do
        schema({ '$ref' => '#/components/schemas/Status'})

        run_test!
      end

      response '400', 'Missing parameters' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:status) { nil }

        run_test!
      end

      response '401', 'Access token is missing or invalid' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:Authorization) { nil }

        run_test!
      end

      response '422', 'The changes requested could not be processed' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:status) { { title: nil, notes: '1337 Notes' } }

        run_test!
      end
    end
  end

  path '/statuses/{id}' do
    parameter name: :id, in: :path, type: :string

    let(:id) { user_status.id }

    get 'Show status' do
      tags 'Statuses'
      description 'Returns the information for a specific status.'
      produces 'application/json'

      response '200', 'Success' do
        schema({ '$ref' => '#/components/schemas/Status'})

        run_test!
      end

      response '401', 'Access token is missing or invalid' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:Authorization) { nil }

        run_test!
      end

      response '403', 'You don\'t have permission to do that' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:id) { other_status.id }

        run_test!
      end

      response '404', 'The specified resource was not found' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:id) { 1337 }

        run_test!
      end
    end

    patch 'Update status' do
      tags 'Statuses'
      description 'Update an existing status.'

      parameter name: :status, in: :body, schema: {
        '$ref' => '#/components/schemas/Status'
      }
      consumes 'application/json'
      let(:status) { { title: Faker::String.random } }

      response '200', 'Success' do
        run_test!
      end

      response '400', 'Missing parameters' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:status) { nil }

        run_test!
      end

      response '401', 'Not authenticated' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:Authorization) { nil }

        run_test!
      end

      response '403', 'Not authorized' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:id) { other_status.id }

        run_test!
      end

      response '404', 'Not Found' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:id) { 1337 }

        run_test!
      end

      response '422', 'Failed to process status' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:status) { { title: nil, notes: '1337 Notes' } }

        run_test!
      end
    end

    delete 'Destroy status' do
      tags 'Statuses'
      description 'Destroy a status.'
      produces 'application/json'

      response '200', 'Success' do
        # TODO schema for `head :ok`?

        run_test!
      end

      response '401', 'Access token is missing or invalid' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:Authorization) { nil }

        run_test!
      end

      response '403', 'You don\'t have permission to do that' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:id) { other_status.id }

        run_test!
      end

      response '404', 'The specified resource was not found' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:id) { 1337 }

        run_test!
      end
    end
  end
end
