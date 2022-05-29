require 'swagger_helper'

RSpec.describe 'Contexts' do
  let(:user) { create :user }
  let(:user_session) { create :user_session, user: user }
  let(:token) do
    # This is dumb and jank, fix it.
    UserSessionsController.new.issue_jwt_token(
      { user_session_id: user_session.id.to_s }
    )
  end
  let(:Authorization) { "Bearer #{token}" }
  let!(:user_context) { create :context, user: user }
  let!(:other_context) { create :context }

  path '/contexts' do
    get 'Get contexts' do
      tags 'Contexts'
      description 'Returns an array of the current user\'s contexts.'
      produces 'application/json'

      response '200', 'Success' do
        schema({ '$ref' => '#/components/schemas/ArrayOfContexts'})

        run_test!
      end

      response '401', 'Access token is missing or invalid' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:Authorization) { nil }

        run_test!
      end
    end

    post 'Create new context' do
      tags 'Contexts'
      description 'Create a new context for the current user.'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :context, in: :body, schema: {
        '$ref' => '#/components/schemas/Context'
      }, required: true

      let(:context) { { title: Faker::String.random } }

      response '200', 'Successfully created new context' do
        schema({ '$ref' => '#/components/schemas/Context'})

        run_test!
      end

      response '400', 'Missing parameters' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:context) { nil }

        run_test!
      end

      response '401', 'Access token is missing or invalid' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:Authorization) { nil }

        run_test!
      end

      response '422', 'The changes requested could not be processed' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:context) { { title: nil, notes: '1337 Notes' } }

        run_test!
      end
    end
  end

  path '/contexts/{id}' do
    parameter name: :id, in: :path, type: :string

    let(:id) { user_context.id }

    get 'Show context' do
      tags 'Contexts'
      description 'Returns the information for a specific context.'
      produces 'application/json'

      response '200', 'Success' do
        schema({ '$ref' => '#/components/schemas/Context'})

        run_test!
      end

      response '401', 'Access token is missing or invalid' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:Authorization) { nil }

        run_test!
      end

      response '403', 'You don\'t have permission to do that' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:id) { other_context.id }

        run_test!
      end

      response '404', 'The specified resource was not found' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:id) { 1337 }

        run_test!
      end
    end

    patch 'Update context' do
      tags 'Contexts'
      description 'Update an existing context.'

      parameter name: :context, in: :body, schema: {
        '$ref' => '#/components/schemas/Context'
      }
      consumes 'application/json'

      let(:context) { { title: Faker::String.random } }

      response '200', 'Success' do
        run_test!
      end

      response '400', 'Missing parameters' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:context) { nil }

        run_test!
      end

      response '401', 'Not authenticated' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:Authorization) { nil }

        run_test!
      end

      response '403', 'Not authorized' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:id) { other_context.id }

        run_test!
      end

      response '404', 'Not Found' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:id) { 1337 }

        run_test!
      end

      response '422', 'Failed to process context' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:context) { { title: nil, notes: '1337 Notes' } }

        run_test!
      end
    end

    delete 'Destroy context' do
      tags 'Contexts'
      description 'Destroy a context.'
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

        let(:id) { other_context.id }

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
