require 'swagger_helper'

RSpec.describe 'Waiting Fors' do
  let(:user) { create :user }
  let(:user_session) { create :user_session, user: user }
  let(:token) do
    # This is dumb and jank, fix it.
    UserSessionsController.new.issue_jwt_token(
      { user_session_id: user_session.id.to_s }
    )
  end
  let(:Authorization) { "Bearer #{token}" }
  let!(:user_waiting_for) { create :waiting_for, user: user }
  let!(:other_waiting_for) { create :waiting_for }

  path '/waiting_fors' do
    get 'Get waiting fors' do
      tags 'Waiting Fors'
      description 'Returns an array of the current user\'s waiting fors.'
      produces 'application/json'

      response '200', 'Success' do
        schema({ '$ref' => '#/components/schemas/ArrayOfWaitingFors'})

        run_test!
      end

      response '401', 'Access token is missing or invalid' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:Authorization) { nil }

        run_test!
      end
    end

    post 'Create new waiting for' do
      tags 'Waiting Fors'
      description 'Create a new waiting for for the current user.'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :waiting_for, in: :body, schema: {
        '$ref' => '#/components/schemas/WaitingFor'
      }, required: true

      let(:waiting_for) do
        { title: Faker::String.random, delegated_to: Faker::Name.name }
      end

      response '200', 'Successfully created new waiting for' do
        schema({ '$ref' => '#/components/schemas/WaitingFor'})

        run_test!
      end

      response '400', 'Missing parameters' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:waiting_for) { nil }

        run_test!
      end

      response '401', 'Access token is missing or invalid' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:Authorization) { nil }

        run_test!
      end

      response '422', 'The changes requested could not be processed' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:waiting_for) { { title: nil, notes: '1337 Notes' } }

        run_test!
      end
    end
  end

  path '/waiting_fors/{id}' do
    parameter name: :id, in: :path, type: :string

    let(:id) { user_waiting_for.id }

    get 'Show waiting for' do
      tags 'Waiting Fors'
      description 'Returns the information for a specific waiting for.'
      produces 'application/json'

      response '200', 'Success' do
        schema({ '$ref' => '#/components/schemas/WaitingFor'})

        run_test!
      end

      response '401', 'Access token is missing or invalid' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:Authorization) { nil }

        run_test!
      end

      response '403', 'You don\'t have permission to do that' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:id) { other_waiting_for.id }

        run_test!
      end

      response '404', 'The specified resource was not found' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:id) { 1337 }

        run_test!
      end
    end

    patch 'Update waiting for' do
      tags 'Waiting Fors'
      description 'Update an existing waiting_for.'

      parameter name: :waiting_for, in: :body, schema: {
        '$ref' => '#/components/schemas/WaitingFor'
      }
      consumes 'application/json'

      let(:waiting_for) { { title: Faker::String.random } }

      response '200', 'Success' do
        run_test!
      end

      response '400', 'Missing parameters' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:waiting_for) { nil }

        run_test!
      end

      response '401', 'Not authenticated' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:Authorization) { nil }

        run_test!
      end

      response '403', 'Not authorized' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:id) { other_waiting_for.id }

        run_test!
      end

      response '404', 'Not Found' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:id) { 1337 }

        run_test!
      end

      response '422', 'Failed to process waiting for' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:waiting_for) { { title: nil, notes: '1337 Notes' } }

        run_test!
      end
    end

    delete 'Destroy waiting for' do
      tags 'Waiting Fors'
      description 'Destroy a waiting for.'
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

        let(:id) { other_waiting_for.id }

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
