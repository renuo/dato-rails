# frozen_string_literal: true

require "rails_helper"

RSpec.describe Dato::Config, :vcr do
  it "has some values" do
    expect(described_class.build_trigger_id).to be_present
  end
end
