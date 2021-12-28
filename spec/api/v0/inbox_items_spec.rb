require 'swagger_helper'

RSpec.describe 'Inbox Items' do
  let(:user) { create :user }
  let(:user_session) { create :user_session, user: user }
  let(:token) do
    # This is dumb and jank, fix it.
    UserSessionsController.new.issue_jwt_token(
      { user_session_id: user_session.id.to_s }
    )
  end
  let(:Authorization) { "Bearer #{token}" }
  let!(:user_inbox_item) { create :inbox_item, user: user }
  let!(:other_inbox_item) { create :inbox_item }

  path '/inbox_items' do
    get 'Returns an array of the current user\'s inbox items.' do
      response '200', 'Success' do
        run_test!
      end

      response '401', 'Not authenticated' do
        let(:Authorization) { nil }

        run_test!
      end
    end

    post 'Create a new inbox item for the current user.' do
      parameter name: :inbox_item, in: :body, schema: {
        '$ref' => '#/components/schemas/InboxItem'
      }
      consumes 'application/json'

      let(:inbox_item) { { title: Faker::String.random } }

      response '200', 'Successfully created new inbox item' do
        run_test!
      end

      response '400', 'Missing parameters' do
        let(:inbox_item) { nil }

        run_test!
      end

      response '401', 'Not authenticated' do
        let(:Authorization) { nil }

        run_test!
      end

      response '422', 'Failed to process inbox item' do
        let(:inbox_item) { { title: nil, notes: '1337 Notes' } }

        run_test!
      end
    end
  end

  path '/inbox_items/{id}' do
    parameter name: :id, in: :path, type: :string
    let(:id) { user_inbox_item.id }

    get 'Returns the information for a specific inbox item.' do
      response '200', 'Success' do
        run_test!
      end

      response '401', 'Not authenticated' do
        let(:Authorization) { nil }

        run_test!
      end

      response '403', 'Not authorized' do
        let(:id) { other_inbox_item.id }

        run_test!
      end

      response '404', 'Not Found' do
        let(:id) { 1337 }

        run_test!
      end
    end

    patch 'Update an existing inbox_item.' do
      parameter name: :inbox_item, in: :body, schema: {
        '$ref' => '#/components/schemas/InboxItem'
      }
      consumes 'application/json'

      let(:inbox_item) { { title: Faker::String.random } }

      response '200', 'Success' do
        run_test!
      end

      response '400', 'Missing parameters' do
        let(:inbox_item) { nil }

        run_test!
      end

      response '401', 'Not authenticated' do
        let(:Authorization) { nil }

        run_test!
      end

      response '403', 'Not authorized' do
        let(:id) { other_inbox_item.id }

        run_test!
      end

      response '404', 'Not Found' do
        let(:id) { 1337 }

        run_test!
      end

      response '422', 'Failed to process inbox item' do
        let(:inbox_item) { { title: nil, notes: '1337 Notes' } }

        run_test!
      end
    end

    delete 'Destroy a inbox item.' do
      response '200', 'Success' do
        run_test!
      end

      response '401', 'Not authenticated' do
        let(:Authorization) { nil }

        run_test!
      end

      response '403', 'Not authorized' do
        let(:id) { other_inbox_item.id }

        run_test!
      end

      response '404', 'Not Found' do
        let(:id) { 1337 }

        run_test!
      end
    end
  end
end
