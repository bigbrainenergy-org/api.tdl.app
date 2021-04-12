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
    get 'Returns an array of the current user\'s lists.' do
      response '200', 'Success' do
        run_test!
      end

      response '401', 'Not authenticated' do
        let(:Authorization) { nil }

        run_test!
      end
    end

    post 'Create a new list for the current user.' do
      parameter name: :list, in: :body, schema: {
        '$ref' => '#/components/schemas/List'
      }
      consumes 'application/json'

      let(:list) { { title: Faker::String.random } }

      response '200', 'Successfully created new list' do
        run_test!
      end

      response '400', 'Missing parameters' do
        let(:list) { nil }

        run_test!
      end

      response '401', 'Not authenticated' do
        let(:Authorization) { nil }

        run_test!
      end

      response '422', 'Failed to process list' do
        let(:list) { { title: user_list.title } }

        run_test!
      end
    end
  end

  path '/lists/sync-ordering' do
    patch 'Update the ordering for current user\'s lists.' do
      parameter name: :lists, in: :body
      consumes 'application/json'

      response '200', 'Success' do
        let(:lists) { { lists: [{ id: user_list.id, order: 1337 }] } }

        run_test!
      end

      response '401', 'Not authenticated' do
        let(:Authorization) { nil }
        let(:lists) { { lists: [{ id: user_list.id, order: 1337 }] } }

        run_test!
      end

      response '403', 'Not authorized' do
        let(:lists) { { lists: [{ id: other_list.id, order: 1337 }] } }

        run_test!
      end

      response '422', 'Failed to process list' do
        let(:lists) { { lists: [{ id: user_list.id, order: 'NaN' }] } }

        run_test!
      end
    end
  end

  path '/lists/{id}' do
    parameter name: :id, in: :path, type: :string
    let(:id) { user_list.id }

    get 'Returns the information for a specific list.' do
      response '200', 'Success' do
        run_test!
      end

      response '401', 'Not authenticated' do
        let(:Authorization) { nil }

        run_test!
      end

      response '403', 'Not authorized' do
        let(:id) { other_list.id }

        run_test!
      end

      response '404', 'Not Found' do
        let(:id) { 1337 }

        run_test!
      end
    end

    patch 'Update an existing list.' do
      parameter name: :list, in: :body, schema: {
        '$ref' => '#/components/schemas/List'
      }
      consumes 'application/json'

      let(:list) { { title: Faker::String.random } }

      response '200', 'Success' do
        run_test!
      end

      response '400', 'Missing parameters' do
        let(:list) { nil }

        run_test!
      end

      response '401', 'Not authenticated' do
        let(:Authorization) { nil }

        run_test!
      end

      response '403', 'Not authorized' do
        let(:id) { other_list.id }

        run_test!
      end

      response '404', 'Not Found' do
        let(:id) { 1337 }

        run_test!
      end

      response '422', 'Failed to process list' do
        let(:list) { { title: nil, order: 1337 } }

        run_test!
      end
    end

    delete 'Destroy a list.' do
      response '200', 'Success' do
        run_test!
      end

      response '401', 'Not authenticated' do
        let(:Authorization) { nil }

        run_test!
      end

      response '403', 'Not authorized' do
        let(:id) { other_list.id }

        run_test!
      end

      response '404', 'Not Found' do
        let(:id) { 1337 }

        run_test!
      end

      response '422', 'Failed to process list' do
        before do
          create :task, list: user_list, user: user_list.user
        end

        run_test!
      end
    end
  end
end
