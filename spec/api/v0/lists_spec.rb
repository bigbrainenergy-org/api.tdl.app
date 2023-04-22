require 'swagger_helper'

RSpec.describe 'Lists' do
  let(:user) { create :user }
  let(:user_session) { create :user_session, user: user }
  let(:token) do
    # This is dumb and jank, fix it.
    UserSessionsController.new.issue_jwt_token(
      { user_session_id: user_session.id.to_s }
    )
  end
  let(:Authorization) { "Bearer #{token}" }
  let!(:user_list) { create :list, user: user }
  let!(:other_list) { create :list }

  path '/lists' do
    get 'Get lists' do
      tags 'Lists'
      description 'Returns an array of the current user\'s lists.'
      produces 'application/json'

      response '200', 'Success' do
        schema({ '$ref' => '#/components/schemas/ArrayOfLists'})

        run_test!
      end

      response '401', 'Access token is missing or invalid' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:Authorization) { nil }

        run_test!
      end
    end

    post 'Create new list' do
      tags 'Lists'
      description 'Create a new list for the current user.'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :list, in: :body, schema: {
        '$ref' => '#/components/schemas/List'
      }, required: true

      let(:list) { { title: Faker::String.random } }

      response '200', 'Successfully created new list' do
        schema({ '$ref' => '#/components/schemas/List'})

        run_test!
      end

      response '400', 'Missing parameters' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:list) { nil }

        run_test!
      end

      response '401', 'Access token is missing or invalid' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:Authorization) { nil }

        run_test!
      end

      response '422', 'The changes requested could not be processed' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:list) { { title: nil, notes: '1337 Notes' } }

        run_test!
      end
    end
  end

  path '/lists/{id}' do
    parameter name: :id, in: :path, type: :string

    let(:id) { user_list.id }

    get 'Show list' do
      tags 'Lists'
      description 'Returns the information for a specific list.'
      produces 'application/json'

      response '200', 'Success' do
        schema({ '$ref' => '#/components/schemas/List'})

        run_test!
      end

      response '401', 'Access token is missing or invalid' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:Authorization) { nil }

        run_test!
      end

      response '403', 'You don\'t have permission to do that' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:id) { other_list.id }

        run_test!
      end

      response '404', 'The specified resource was not found' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:id) { 1337 }

        run_test!
      end
    end

    patch 'Update list' do
      tags 'Lists'
      description 'Update an existing list.'

      parameter name: :list, in: :body, schema: {
        '$ref' => '#/components/schemas/List'
      }
      consumes 'application/json'
      let(:id) { @list.id }
      let(:list) { { title: Faker::String.random } }

      response '200', 'Success' do
        run_test!
      end

      response '400', 'Missing parameters' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:list) { nil }

        run_test!
      end

      response '401', 'Not authenticated' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:Authorization) { nil }

        run_test!
      end

      response '403', 'Not authorized' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:id) { other_list.id }

        run_test!
      end

      response '404', 'Not Found' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:id) { 1337 }

        run_test!
      end

      response '422', 'Failed to process list' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:list) { { title: nil, notes: '1337 Notes' } }

        run_test!
      end
    end

    delete 'Destroy list' do
      tags 'Lists'
      description 'Destroy a list.'
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

        let(:id) { other_list.id }

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
