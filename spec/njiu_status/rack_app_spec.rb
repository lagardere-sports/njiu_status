require "spec_helper"

RSpec.describe NjiuStatus::RackApp do
  let(:app) { NjiuStatus::RackApp }
  let(:check) { NjiuStatus::Check }
  let(:response) { last_response }

  shared_examples "an unknown check" do
    it "returns 404" do
      expect(response.status).to eq(404)
    end

    it "renders error" do
      expect(response.body).to include("error")
      expect(response.body).to include("unknown check")
    end
  end

  describe "unknown check" do
    before { get "/foobar" }
    it_behaves_like "an unknown check"
  end

  describe "deeply nested unknown check" do
    before { get "/foo/bar/baz" }
    it_behaves_like "an unknown check"
  end

  describe "root" do
    before { get "/" }
    it_behaves_like "an unknown check"
  end

  describe "successful check" do
    let(:handler) do
      ->(request, response) { response.write("OK"); response.status = 200 }
    end

    before do
      check.add name: "foo", handler: handler
      get "/foo"
    end

    it "returns 200" do
      expect(response.status).to eq(200)
    end

    it "renders content" do
      expect(response.body).to eq("OK")
    end
  end
end
