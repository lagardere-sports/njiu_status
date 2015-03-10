require "spec_helper"

RSpec.describe NjiuStatus::RackApp do
  let(:app) { NjiuStatus::RackApp }
  let(:check) { NjiuStatus::Check }
  let(:config) { NjiuStatus::Configuration }
  let(:response) { last_response }

  before { config.token = nil }

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

  shared_examples "a successful check" do
    it "returns 200" do
      expect(response.status).to eq(200)
    end

    it "renders content" do
      expect(response.body).to eq(body)
    end
  end

  describe "successful check" do
    let(:handler) do
      ->(request, response) { response.write(body); response.status = 200 }
    end

    describe "top-level" do
      let(:body) { "FOO" }

      before do
        check.add name: "foo", handler: handler
        get "/foo"
      end

      it_behaves_like "a successful check"
    end

    describe "nested" do
      let(:body) { "NESTED" }

      before do
        check.add name: "foo/nested", handler: handler
        get "/foo/nested"
      end

      it_behaves_like "a successful check"
    end
  end

  describe "token check" do
    before do
      check.add name: "foo", handler: -> (_,_) {}
    end

    context "success" do
      it "returns 200" do
        config.token = "foo123"
        get "/foo?token=foo123"
      end
    end

    shared_examples "an invalid token" do
      it "returns 401" do
        expect(response.status).to eq(401)
      end

      it "renders error" do
        expect(response.body).to include("error")
        expect(response.body).to include("token invalid or missing")
      end
    end

    context "mismatch" do
      before do
        config.token = "foo123"
        get "/foo?token=foo123123"
      end

      it_behaves_like "an invalid token"
    end

    context "missing" do
      before do
        config.token = "foo123"
        get "/foo"
      end

      it_behaves_like "an invalid token"
    end
  end
end
