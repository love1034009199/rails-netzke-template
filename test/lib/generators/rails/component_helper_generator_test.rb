require 'test_helper'
require 'generators/rails/component_helper/component_helper_generator'

class Rails::ComponentHelperGeneratorTest < Rails::Generators::TestCase
  tests Rails::ComponentHelperGenerator
  destination Rails.root.join('tmp/generators')
  setup :prepare_destination

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["arguments"]
  #   end
  # end
end
