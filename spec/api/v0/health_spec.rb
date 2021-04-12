require 'swagger_helper'

RSpec.describe 'Health' do
  path '/health' do
    get 'Returns API health status' do
      security []

      response '200', 'API is healthy' do
        run_test!
      end

      response '503', 'API is currently unavailable' do
        before do
          allow(User).to receive(:any?).and_raise StandardError
        end

        run_test!
      end
    end
  end
end
