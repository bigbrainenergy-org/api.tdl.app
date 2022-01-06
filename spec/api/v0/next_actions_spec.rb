require 'swagger_helper'

RSpec.describe 'Next Actions' do
  let(:user) { create :user }
  let(:user_session) { create :user_session, user: user }
  let(:token) do
    # This is dumb and jank, fix it.
    UserSessionsController.new.issue_jwt_token(
      { user_session_id: user_session.id.to_s }
    )
  end
  let(:Authorization) { "Bearer #{token}" }
  let!(:user_next_action) { create :next_action, user: user }
  let!(:other_next_action) { create :next_action }

  path '/next_actions' do
    get 'Get next actions' do
      tags 'Next Actions'
      description 'Returns an array of the current user\'s next actions.'
      produces 'application/json'

      response '200', 'Success' do
        schema({ '$ref' => '#/components/schemas/ArrayOfNextActions'})

        run_test!
      end

      response '401', 'Access token is missing or invalid' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:Authorization) { nil }

        run_test!
      end
    end

    post 'Create new next action' do
      tags 'Next Actions'
      description 'Create a new next action for the current user.'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :next_action, in: :body, schema: {
        '$ref' => '#/components/schemas/NextAction'
      }, required: true

      let(:next_action) { { title: Faker::String.random } }

      response '200', 'Successfully created new next action' do
        schema({ '$ref' => '#/components/schemas/NextAction'})

        run_test!
      end

      response '400', 'Missing parameters' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:next_action) { nil }

        run_test!
      end

      response '401', 'Access token is missing or invalid' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:Authorization) { nil }

        run_test!
      end

      response '422', 'The changes requested could not be processed' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:next_action) { { title: nil, notes: '1337 Notes' } }

        run_test!
      end
    end
  end

  path '/next_actions/{id}' do
    parameter name: :id, in: :path, type: :string

    let(:id) { user_next_action.id }

    get 'Show next action' do
      tags 'Next Actions'
      description 'Returns the information for a specific next action.'
      produces 'application/json'

      response '200', 'Success' do
        schema({ '$ref' => '#/components/schemas/NextAction'})

        run_test!
      end

      response '401', 'Access token is missing or invalid' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:Authorization) { nil }

        run_test!
      end

      response '403', 'You don\'t have permission to do that' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:id) { other_next_action.id }

        run_test!
      end

      response '404', 'The specified resource was not found' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:id) { 1337 }

        run_test!
      end
    end

    patch 'Update next action' do
      tags 'Next Actions'
      description 'Update an existing next_action.'

      parameter name: :next_action, in: :body, schema: {
        '$ref' => '#/components/schemas/NextAction'
      }
      consumes 'application/json'

      let(:next_action) { { title: Faker::String.random } }

      response '200', 'Success' do
        run_test!
      end

      response '400', 'Missing parameters' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:next_action) { nil }

        run_test!
      end

      response '401', 'Not authenticated' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:Authorization) { nil }

        run_test!
      end

      response '403', 'Not authorized' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:id) { other_next_action.id }

        run_test!
      end

      response '404', 'Not Found' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:id) { 1337 }

        run_test!
      end

      response '422', 'Failed to process next action' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:next_action) { { title: nil, notes: '1337 Notes' } }

        run_test!
      end
    end

    delete 'Destroy next action' do
      tags 'Next Actions'
      description 'Destroy a next action.'
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

        let(:id) { other_next_action.id }

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
