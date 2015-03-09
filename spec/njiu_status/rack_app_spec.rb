require "spec_helper"

RSpec.describe NjiuStatus::RackApp do
  let(:app) { NjiuStatus::RackApp }
  let(:response) { last_response }

  describe ".checks" do
    it "is initialized with empty hash" do
      expect(app.checks).to eq({})
    end
  end

  describe ".add_check" do
    let(:handler) { ->(_,_){} }

    before { app.add_check(name: "foo", handler: handler) }

    it "adds slash to name" do
      expect(app.checks.keys).to eq(["/foo"])
    end

    it "assigns handler" do
      expect(app.checks.values).to eq([handler])
    end
  end

  shared_examples "an unknown check" do
    it "returns 404" do
      expect(response.status).to eq(404)
    end

    it "renders error" do
      expect(response.body).to include("error")
      expect(response.body).to include("unknown check")
    end
  end

  describe ".call" do
    context "unknown check" do
      before { get "/foobar" }
      it_behaves_like "an unknown check"
    end

    context "deeply nested unknown check" do
      before { get "/foo/bar/baz" }
      it_behaves_like "an unknown check"
    end

    context "root" do
      before { get "/" }
      it_behaves_like "an unknown check"
    end

    context "successful check" do
      let(:handler) do
        ->(request, response) { response.write("OK"); response.status = 200 }
      end

      before do
        app.add_check name: "foo", handler: handler
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
end
