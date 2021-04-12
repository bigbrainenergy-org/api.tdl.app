require 'swagger_helper'

RSpec.describe 'Tags' do
  let(:user) { create :user }
  let(:user_session) { create :user_session, user: user }
  let(:token) do
    # This is dumb and jank, fix it.
    UserSessionsController.new.issue_jwt_token(
      { user_session_id: user_session.id.to_s }
    )
  end
  let(:Authorization) { "Bearer #{token}" }
  let!(:user_tag) { create :tag, user: user }
  let!(:other_tag) { create :tag }

  path '/tags' do
    get 'Returns an array of the current user\'s tags.' do
      response '200', 'Success' do
        run_test!
      end

      response '401', 'Not authenticated' do
        let(:Authorization) { nil }

        run_test!
      end
    end

    post 'Create a new tag for the current user.' do
      parameter name: :tag, in: :body, schema: {
        '$ref' => '#/components/schemas/Tag'
      }
      consumes 'application/json'

      let(:tag) do
        {
          title: Faker::String.random,
          color: Faker::Color.hex_color
        }
      end

      response '200', 'Successfully created new tag' do
        run_test!
      end

      response '400', 'Missing parameters' do
        let(:tag) { nil }

        run_test!
      end

      response '401', 'Not authenticated' do
        let(:Authorization) { nil }

        run_test!
      end

      response '422', 'Failed to process tag' do
        let(:tag) do
          {
            title: user_tag.title,
            color: [Faker::Color.hex_color, Faker::Color.color_name].sample
          }
        end

        run_test!
      end
    end
  end

  path '/tags/sync-ordering' do
    patch 'Update the ordering for current user\'s tags.' do
      parameter name: :tags, in: :body
      consumes 'application/json'

      response '200', 'Success' do
        let(:tags) { { tags: [{ id: user_tag.id, order: 1337 }] } }

        run_test!
      end

      response '401', 'Not authenticated' do
        let(:Authorization) { nil }
        let(:tags) { { tags: [{ id: user_tag.id, order: 1337 }] } }

        run_test!
      end

      response '403', 'Not authorized' do
        let(:tags) { { tags: [{ id: other_tag.id, order: 1337 }] } }

        run_test!
      end

      response '422', 'Failed to process tag' do
        let(:tags) { { tags: [{ id: user_tag.id, order: 'NaN' }] } }

        run_test!
      end
    end
  end

  path '/tags/{id}' do
    parameter name: :id, in: :path, type: :string
    let(:id) { user_tag.id }

    get 'Returns the information for a specific tag.' do
      response '200', 'Success' do
        run_test!
      end

      response '401', 'Not authenticated' do
        let(:Authorization) { nil }

        run_test!
      end

      response '403', 'Not authorized' do
        let(:id) { other_tag.id }

        run_test!
      end

      response '404', 'Not Found' do
        let(:id) { 1337 }

        run_test!
      end
    end

    patch 'Update an existing tag.' do
      parameter name: :tag, in: :body, schema: {
        '$ref' => '#/components/schemas/Tag'
      }
      consumes 'application/json'

      let(:tag) { { title: Faker::String.random } }

      response '200', 'Success' do
        run_test!
      end

      response '400', 'Missing parameters' do
        let(:tag) { nil }

        run_test!
      end

      response '401', 'Not authenticated' do
        let(:Authorization) { nil }

        run_test!
      end

      response '403', 'Not authorized' do
        let(:id) { other_tag.id }

        run_test!
      end

      response '404', 'Not Found' do
        let(:id) { 1337 }

        run_test!
      end

      response '422', 'Failed to process tag' do
        let(:tag) { { title: nil, order: 1337 } }

        run_test!
      end
    end

    delete 'Destroy a tag.' do
      response '200', 'Success' do
        run_test!
      end

      response '401', 'Not authenticated' do
        let(:Authorization) { nil }

        run_test!
      end

      response '403', 'Not authorized' do
        let(:id) { other_tag.id }

        run_test!
      end

      response '404', 'Not Found' do
        let(:id) { 1337 }

        run_test!
      end
    end
  end
end
