# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"
require "spec_helper"

require File.expand_path("dummy/config/environment.rb", __dir__)

require "rspec/rails"
require "view_component/test_helpers"

# Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.include ViewComponent::TestHelpers, type: :component
  config.include Capybara::RSpecMatchers, type: :component
end

module MarkdownRenderHelper
  def render_inline_md(component)
    with_format(:md) { render_inline(component).to_s }
  end
end

RSpec.configure do |config|
  config.include MarkdownRenderHelper, type: :component
end
