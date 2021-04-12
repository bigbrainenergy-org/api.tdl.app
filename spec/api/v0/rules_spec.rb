require 'swagger_helper'

RSpec.describe 'Rules' do
  let(:user) { create :user }
  let(:user_session) { create :user_session, user: user }
  let(:token) do
    # This is dumb and jank, fix it.
    UserSessionsController.new.issue_jwt_token(
      { user_session_id: user_session.id.to_s }
    )
  end
  let(:Authorization) { "Bearer #{token}" }
  let(:pre) { create :task, user: user }
  let(:post) { create :task, user: user }
  let!(:user_rule) { create :rule, pre: pre, post: post }
  let!(:other_rule) { create :rule }

  path '/rules' do
    get 'Returns an array of the current user\'s rules.' do
      response '200', 'Success' do
        run_test!
      end

      response '401', 'Not authenticated' do
        let(:Authorization) { nil }

        run_test!
      end
    end
  end
end
