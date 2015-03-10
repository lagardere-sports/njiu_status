require "spec_helper"

begin
  require "rails"
rescue LoadError
  puts "Warning: integration specs are skipped. Use 'appraisal rspec' to run the full test suite."
end

RSpec.describe "Integration" do
  let(:app) { Rails.application }
  let(:response) { last_response }

  shared_examples "a properly configured rails app" do
    before do
      get "/status/rails_version"
    end

    it "returns 200" do
      expect(response.status).to eq(200)
    end

    it "renders proper version" do
      expect(response.body).to eq(version)
    end
  end

  describe "Rails 3.2" do
    let(:version) { "3.2.21" }
    before do
      require "dummy/rails_32"
    end

    it_behaves_like "a properly configured rails app"
  end if defined?(Rails) && Rails.version.start_with?("3.2")

  describe "Rails 4.2" do
    let(:version) { "4.2.0" }
    before do
      require "dummy/rails_42"
    end

    it_behaves_like "a properly configured rails app"
  end if defined?(Rails) && Rails.version.start_with?("4.2")
end
