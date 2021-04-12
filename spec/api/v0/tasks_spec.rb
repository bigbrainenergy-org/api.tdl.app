require 'swagger_helper'

RSpec.describe 'Tasks' do
  let(:user) { create :user }
  let(:user_session) { create :user_session, user: user }
  let(:token) do
    # This is dumb and jank, fix it.
    UserSessionsController.new.issue_jwt_token(
      { user_session_id: user_session.id.to_s }
    )
  end
  let(:Authorization) { "Bearer #{token}" }
  let(:user_list) { create :list, user: user }
  let!(:user_task) { create :task, user: user, list: user_list }
  let!(:other_task) { create :task }

  path '/tasks' do
    get 'Returns an array of the current user\'s tasks.' do
      response '200', 'Success' do
        run_test!
      end

      response '401', 'Not authenticated' do
        let(:Authorization) { nil }

        run_test!
      end
    end

    post 'Create a new task for the current user.' do
      parameter name: :task, in: :body, schema: {
        '$ref' => '#/components/schemas/List'
      }
      consumes 'application/json'

      let(:task) { { title: Faker::String.random, list_id: user_list.id } }

      response '200', 'Successfully created new task' do
        run_test!
      end

      response '400', 'Missing parameters' do
        let(:task) { nil }

        run_test!
      end

      response '401', 'Not authenticated' do
        let(:Authorization) { nil }

        run_test!
      end

      response '403', 'Not authorized' do
        let(:task) { { title: user_task.title } }

        run_test!
      end

      response '422', 'Failed to process task' do
        let(:task) { { title: user_task.title, list_id: user_list.id } }

        run_test!
      end
    end
  end

  path '/tasks/sync-ordering' do
    patch 'Update the ordering for current user\'s tasks.' do
      parameter name: :tasks, in: :body
      consumes 'application/json'

      response '200', 'Success' do
        let(:tasks) { { tasks: [{ id: user_task.id, order: 1337 }] } }

        run_test!
      end

      response '401', 'Not authenticated' do
        let(:Authorization) { nil }
        let(:tasks) { { tasks: [{ id: user_task.id, order: 1337 }] } }

        run_test!
      end

      response '403', 'Not authorized' do
        let(:tasks) { { tasks: [{ id: other_task.id, order: 1337 }] } }

        run_test!
      end

      response '422', 'Failed to process list' do
        let(:tasks) { { tasks: [{ id: user_task.id, order: 'NaN' }] } }

        run_test!
      end
    end
  end

  path '/tasks/{id}' do
    parameter name: :id, in: :path, type: :string
    let(:id) { user_task.id }

    get 'Returns the information for a specific list.' do
      response '200', 'Success' do
        run_test!
      end

      response '401', 'Not authenticated' do
        let(:Authorization) { nil }

        run_test!
      end

      response '403', 'Not authorized' do
        let(:id) { other_task.id }

        run_test!
      end

      response '404', 'Not Found' do
        let(:id) { 1337 }

        run_test!
      end
    end

    patch 'Update an existing task.' do
      parameter name: :task, in: :body, schema: {
        '$ref' => '#/components/schemas/Task'
      }
      consumes 'application/json'

      let(:task) { { title: Faker::String.random } }

      response '200', 'Success' do
        run_test!
      end

      response '400', 'Missing parameters' do
        let(:task) { nil }

        run_test!
      end

      response '401', 'Not authenticated' do
        let(:Authorization) { nil }

        run_test!
      end

      response '403', 'Not authorized' do
        let(:id) { other_task.id }

        run_test!
      end

      response '404', 'Not Found' do
        let(:id) { 1337 }

        run_test!
      end

      response '422', 'Failed to process task' do
        let(:task) { { title: nil, order: 1337 } }

        run_test!
      end
    end

    delete 'Destroy a task.' do
      response '200', 'Success' do
        run_test!
      end

      response '401', 'Not authenticated' do
        let(:Authorization) { nil }

        run_test!
      end

      response '403', 'Not authorized' do
        let(:id) { other_task.id }

        run_test!
      end

      response '404', 'Not Found' do
        let(:id) { 1337 }

        run_test!
      end
    end
  end
end
