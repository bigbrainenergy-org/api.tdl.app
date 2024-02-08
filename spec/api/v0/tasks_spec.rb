require 'swagger_helper'

RSpec.describe 'Tasks' do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:list) { create(:list, user: user) }
  let(:other_user_list) { create(:list, user: other_user) }
  let(:user_session) { create(:user_session, user: user) }
  let(:token) do
    # This is dumb and jank, fix it.
    UserSessionsController.new.issue_jwt_token(
      { user_session_id: user_session.id.to_s }
    )
  end
  let(:Authorization) { "Bearer #{token}" }
  let!(:user_task) { create(:task, list: list) }
  let!(:other_task) { create(:task) }

  path '/tasks' do
    get 'Get next tasks' do
      tags 'Next Tasks'
      description 'Returns an array of the current user\'s next tasks.'
      produces 'application/json'

      response '200', 'Success' do
        schema({ '$ref' => '#/components/schemas/ArrayOfTasks' })

        run_test!
      end

      response '401', 'Access token is missing or invalid' do
        schema({ '$ref' => '#/components/schemas/Error' })

        let(:Authorization) { nil }

        run_test!
      end
    end

    post 'Create new task' do
      tags 'Tasks'
      description 'Create a new task for the current user.'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :task, in: :body, schema: {
        '$ref' => '#/components/schemas/Task'
      }, required: true

      let(:task) { { title: Faker::String.random, list_id: list.id } }

      response '200', 'Successfully created new task' do
        schema({ '$ref' => '#/components/schemas/Task' })

        run_test!
      end

      response '400', 'Missing parameters' do
        schema({ '$ref' => '#/components/schemas/Error' })

        let(:task) { nil }

        run_test!
      end

      response '401', 'Access token is missing or invalid' do
        schema({ '$ref' => '#/components/schemas/Error' })

        let(:Authorization) { nil }

        run_test!
      end

      response '422', 'The changes requested could not be processed' do
        schema({ '$ref' => '#/components/schemas/Error' })

        let(:task) { { title: nil, notes: '1337 Notes', list_id: list.id } }

        run_test!
      end
    end
  end

  path '/tasks/bulk' do
    post 'Create multiple new tasks' do
      tags 'Tasks'
      description 'Create multiple new tasks for the current user.'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :tasks, in: :body, schema: {
        '$ref' => '#/components/schemas/ArrayOfTasks'
      }, required: true
      let(:tasks) { [ 
        { title: Faker::String.random, list_id: list.id }, 
        { title: Faker::String.random, list_id: list.id }, 
        { title: Faker::String.random, list_id: list.id }, 
        { title: Faker::String.random, list_id: list.id }, 
        { title: Faker::String.random, list_id: list.id }, 
        { title: Faker::String.random, list_id: list.id } ] }
      response '200', 'Successfully created multiple new tasks' do
        schema({ 'ref' => '#/components/schemas/ArrayOfTasks' })
        run_test!
      end
      response '400', 'Missing parameters' do
        schema({ '$ref' => '#/components/schemas/Error' })
        let(:tasks) { nil }
        run_test!
      end
      response '401', 'Access token is missing or invalid' do
        schema({ '$ref' => '#/components/schemas/Error' })
        let(:Authorization) { nil }
        run_test!
      end
      response '403', 'Not authorized' do
        # if any fail authorization, 403 all (for now)
        # todo: possible to fail some and pass others using custom response type?
        # todo: possible to fail some and pass others on failed circular ref validation?
        schema({ '$ref' => '#/components/schemas/Error' })
        let(:tasks) { [
        { title: Faker::String.random, list_id: list.id }, 
        { title: Faker::String.random, list_id: list.id }, 
        { title: Faker::String.random, list_id: list.id }, 
        { title: Faker::String.random, list_id: list.id }, 
        { title: Faker::String.random, list_id: list.id }, 
        { title: Faker::String.random, list_id: other_user_list.id } ] }
        run_test!
      end
      response '422', 'The changes requested could not be processed' do
        schema({ '$ref' => '#/components/schemas/Error' })
        let(:tasks) { [ { title: nil, notes: '1337 notes', list_id: list.id } ] }
        run_test!
      end
    end

    patch 'Update multiple tasks' do
      tags 'Tasks'
      description 'Update multiple existing tasks.'
      parameter name: :tasks, in: :body, schema: {
        '$ref' => '#/components/schemas/ArrayOfTasks'
      }
      consumes 'application/json'
      produces 'application/json'
      let(:tasks) { [
        { title: Faker::String.random, list_id: list.id }, 
        { title: Faker::String.random, list_id: list.id }, 
        { title: Faker::String.random, list_id: list.id }, 
        { title: Faker::String.random, list_id: list.id }, 
        { title: Faker::String.random, list_id: list.id }, 
        { title: Faker::String.random, list_id: list.id } ] }
      response '200', 'Success' do
        run_test!
      end
      response '400', 'Missing parameters' do
        schema({ '$ref' => '#/components/schemas/Error' })
        let(:tasks) { nil }
        run_test!
      end
      response '401', 'Not authenticated' do
        schema({ '$ref' => '#/components/schemas/Error' })
        let(:Authorization) { nil }
        run_test!
      end
      response '403', 'Not authorized' do
        # if any fail authorization, 403 all (for now)
        # todo: possible to fail some and pass others using custom response type?
        # todo: possible to fail some and pass others on failed circular ref validation?
        schema({ '$ref' => '#/components/schemas/Error' })
        let(:tasks) { [
        { title: Faker::String.random, list_id: list.id }, 
        { title: Faker::String.random, list_id: list.id }, 
        { title: Faker::String.random, list_id: list.id }, 
        { title: Faker::String.random, list_id: list.id }, 
        { title: Faker::String.random, list_id: list.id }, 
        { title: Faker::String.random, list_id: other_user_list.id } ] }
        run_test!
      end
      response '422', 'The changes requested could not be processed' do
        schema({ '$ref' => '#/components/schemas/Error' })
        let(:tasks) { [ { title: nil, notes: '1337 notes', list_id: list.id } ] }
      end
    end
  end

  path '/tasks/{id}' do
    parameter name: :id, in: :path, type: :string

    let(:id) { user_task.id }

    get 'Show next task' do
      tags 'Next Tasks'
      description 'Returns the information for a specific next task.'
      produces 'application/json'

      response '200', 'Success' do
        schema({ '$ref' => '#/components/schemas/Task' })

        run_test!
      end

      response '401', 'Access token is missing or invalid' do
        schema({ '$ref' => '#/components/schemas/Error' })

        let(:Authorization) { nil }

        run_test!
      end

      response '403', 'You don\'t have permission to do that' do
        schema({ '$ref' => '#/components/schemas/Error' })

        let(:id) { other_task.id }

        run_test!
      end

      response '404', 'The specified resource was not found' do
        schema({ '$ref' => '#/components/schemas/Error' })

        let(:id) { 1337 }

        run_test!
      end
    end

    patch 'Update next task' do
      tags 'Next Tasks'
      description 'Update an existing task.'

      parameter name: :task, in: :body, schema: {
        '$ref' => '#/components/schemas/NextAction'
      }
      consumes 'application/json'

      let(:task) { { title: Faker::String.random, list_id: list.id } }

      response '200', 'Success' do
        run_test!
      end

      response '400', 'Missing parameters' do
        schema({ '$ref' => '#/components/schemas/Error' })

        let(:task) { nil }

        run_test!
      end

      response '401', 'Not authenticated' do
        schema({ '$ref' => '#/components/schemas/Error' })

        let(:Authorization) { nil }

        run_test!
      end

      response '403', 'Not authorized' do
        schema({ '$ref' => '#/components/schemas/Error' })

        let(:id) { other_task.id }

        run_test!
      end

      response '404', 'Not Found' do
        schema({ '$ref' => '#/components/schemas/Error' })

        let(:id) { 1337 }

        run_test!
      end

      response '422', 'Failed to process next task' do
        schema({ '$ref' => '#/components/schemas/Error' })

        let(:task) { { title: nil, notes: '1337 Notes' } }

        run_test!
      end
    end

    delete 'Destroy next task' do
      tags 'Next Tasks'
      description 'Destroy a next task.'
      produces 'application/json'

      response '200', 'Success' do
        # TODO: schema for `head :ok`?

        run_test!
      end

      response '401', 'Access token is missing or invalid' do
        schema({ '$ref' => '#/components/schemas/Error' })

        let(:Authorization) { nil }

        run_test!
      end

      response '403', 'You don\'t have permission to do that' do
        schema({ '$ref' => '#/components/schemas/Error' })

        let(:id) { other_task.id }

        run_test!
      end

      response '404', 'The specified resource was not found' do
        schema({ '$ref' => '#/components/schemas/Error' })

        let(:id) { 1337 }

        run_test!
      end
    end
  end
end
