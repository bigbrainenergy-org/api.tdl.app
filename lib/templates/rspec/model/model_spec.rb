require 'rails_helper'

<% module_namespacing do -%>
RSpec.describe <%= class_name %> do
  subject(:record) { build :<%= class_name.underscore %> }

  it 'has valid factory' do
    expect(record).to be_valid
  end

  describe 'associations' do
    # TODO: Add tests or remove placeholder
  end

  describe 'validations' do
    # TODO: Add tests or remove placeholder
  end

  describe 'callbacks' do
    # TODO: Add tests or remove placeholder
  end

  describe 'scopes' do
    # TODO: Add tests or remove placeholder
  end

  describe 'class method' do
    # TODO: Add tests or remove placeholder
  end

  describe 'instance method' do
    # TODO: Add tests or remove placeholder
  end
end
<% end -%>
