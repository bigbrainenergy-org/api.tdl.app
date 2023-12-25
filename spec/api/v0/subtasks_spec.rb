require 'swagger_helper'

RSpec.describe 'Subtasks' do
  let(:user) { create :user }
  let(:list) { create :list, user: user }
  let(:user_session) { create :user_session, user: user }
  let(:token) do
    # This is dumb and jank, fix it.
    UserSessionsController.new.issue_jwt_token(
      { user_session_id: user_session.id.to_s }
    )
  end
  let(:Authorization) { "Bearer #{token}" }
  let!(:user_task) { create :task, list: list }
  let!(:other_task) { create :task }
  let!(:user_subtask) { create :subtask, task: user_task }
  let!(:other_subtask) { create :subtask, task: other_task }

  path '/subtasks' do
    get 'Get subtasks' do
      tags 'Subtasks'
      description 'Returns an array of the current user\'s subtasks.'
      produces 'application/json'

      response '200', 'Success' do
        schema({ '$ref' => '#/components/schemas/ArrayOfSubtasks'})

        run_test!
      end

      response '401', 'Access token is missing or invalid' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:Authorization) { nil }

        run_test!
      end
    end

    post 'Create new task' do
      tags 'Subtasks'
      description 'Create a new subtask for the current user.'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :subtask, in: :body, schema: {
        '$ref' => '#/components/schemas/Subtask'
      }, required: true

      let(:subtask) { { title: Faker::String.random, task_id: user_task.id } }

      response '200', 'Successfully created new subtask' do
        schema({ '$ref' => '#/components/schemas/Subtask'})

        run_test!
      end

      response '400', 'Missing parameters' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:subtask) { nil }

        run_test!
      end

      response '401', 'Access token is missing or invalid' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:Authorization) { nil }

        run_test!
      end

      response '422', 'The changes requested could not be processed' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:subtask) { { title: nil, notes: '1337 Notes', task_id: user_task.id } }

        run_test!
      end
    end
  end

  path '/subtasks/{id}' do
    parameter name: :id, in: :path, type: :string

    let(:id) { user_subtask.id }

    get 'Show subtask' do
      tags 'Subtasks'
      description 'Returns the information for a specific subtask.'
      produces 'application/json'

      response '200', 'Success' do
        schema({ '$ref' => '#/components/schemas/Subtask'})

        run_test!
      end

      response '401', 'Access token is missing or invalid' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:Authorization) { nil }

        run_test!
      end

      response '403', 'You don\'t have permission to do that' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:id) { other_subtask.id }

        run_test!
      end

      response '404', 'The specified resource was not found' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:id) { 1337 }

        run_test!
      end
    end

    patch 'Update subtask' do
      tags 'Subtasks'
      description 'Update an existing task.'

      parameter name: :subtask, in: :body, schema: {
        '$ref' => '#/components/schemas/Subtask'
      }
      consumes 'application/json'

      let(:subtask) { { title: Faker::String.random, task_id: user_task.id } }

      response '200', 'Success' do
        run_test!
      end

      response '400', 'Missing parameters' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:subtask) { nil }

        run_test!
      end

      response '401', 'Not authenticated' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:Authorization) { nil }

        run_test!
      end

      response '403', 'Not authorized' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:id) { other_subtask.id }

        run_test!
      end

      response '404', 'Not Found' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:id) { 1337 }

        run_test!
      end

      response '422', 'Failed to process subtask' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:subtask) { { title: nil, notes: '1337 Notes' } }

        run_test!
      end
    end

    delete 'Destroy subtask' do
      tags 'Subtasks'
      description 'Destroy a subtask.'
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

        let(:id) { other_subtask.id }

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
