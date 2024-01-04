require 'swagger_helper'

RSpec.describe 'Meta' do
  path '/health' do
    get 'API Health Status' do
      tags 'Meta'
      description 'Returns API health status'
      produces 'application/json'
      security []

      response '200', 'API is healthy' do
        run_test!
      end

      response '503', 'API is currently unavailable' do
        schema({ '$ref' => '#/components/schemas/Error' })

        before do
          allow(User).to receive(:any?).and_raise StandardError
        end

        run_test!
      end
    end
  end
end
