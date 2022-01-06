require 'swagger_helper'

RSpec.describe 'Projects' do
  let(:user) { create :user }
  let(:user_session) { create :user_session, user: user }
  let(:token) do
    # This is dumb and jank, fix it.
    UserSessionsController.new.issue_jwt_token(
      { user_session_id: user_session.id.to_s }
    )
  end
  let(:Authorization) { "Bearer #{token}" }
  let!(:user_project) { create :project, user: user }
  let!(:other_project) { create :project }

  path '/projects' do
    get 'Get projects' do
      tags 'Projects'
      description 'Returns an array of the current user\'s projects.'
      produces 'application/json'

      response '200', 'Success' do
        schema({ '$ref' => '#/components/schemas/ArrayOfProjects'})

        run_test!
      end

      response '401', 'Access token is missing or invalid' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:Authorization) { nil }

        run_test!
      end
    end

    post 'Create new project' do
      tags 'Projects'
      description 'Create a new project for the current user.'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :project, in: :body, schema: {
        '$ref' => '#/components/schemas/Project'
      }, required: true

      let(:project) { { title: Faker::String.random } }

      response '200', 'Successfully created new project' do
        schema({ '$ref' => '#/components/schemas/Project'})

        run_test!
      end

      response '400', 'Missing parameters' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:project) { nil }

        run_test!
      end

      response '401', 'Access token is missing or invalid' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:Authorization) { nil }

        run_test!
      end

      response '422', 'The changes requested could not be processed' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:project) { { title: nil, notes: '1337 Notes' } }

        run_test!
      end
    end
  end

  path '/projects/{id}' do
    parameter name: :id, in: :path, type: :string

    let(:id) { user_project.id }

    get 'Show project' do
      tags 'Projects'
      description 'Returns the information for a specific project.'
      produces 'application/json'

      response '200', 'Success' do
        schema({ '$ref' => '#/components/schemas/Project'})

        run_test!
      end

      response '401', 'Access token is missing or invalid' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:Authorization) { nil }

        run_test!
      end

      response '403', 'You don\'t have permission to do that' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:id) { other_project.id }

        run_test!
      end

      response '404', 'The specified resource was not found' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:id) { 1337 }

        run_test!
      end
    end

    patch 'Update project' do
      tags 'Projects'
      description 'Update an existing project.'

      parameter name: :project, in: :body, schema: {
        '$ref' => '#/components/schemas/Project'
      }
      consumes 'application/json'

      let(:project) { { title: Faker::String.random } }

      response '200', 'Success' do
        run_test!
      end

      response '400', 'Missing parameters' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:project) { nil }

        run_test!
      end

      response '401', 'Not authenticated' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:Authorization) { nil }

        run_test!
      end

      response '403', 'Not authorized' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:id) { other_project.id }

        run_test!
      end

      response '404', 'Not Found' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:id) { 1337 }

        run_test!
      end

      response '422', 'Failed to process project' do
        schema({ '$ref' => '#/components/schemas/Error'})

        let(:project) { { title: nil, notes: '1337 Notes' } }

        run_test!
      end
    end

    delete 'Destroy project' do
      tags 'Projects'
      description 'Destroy a project.'
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

        let(:id) { other_project.id }

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
