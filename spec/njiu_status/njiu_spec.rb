require "spec_helper"

RSpec.describe NjiuStatus do
  subject { NjiuStatus }

  describe ".configure" do
    it "yields configuration" do
      subject.configure do |config|
        config.token = "foo123"
      end
      expect(NjiuStatus::Configuration.token).to eq("foo123")
    end
  end

  describe ".config" do
    it "returns configuration" do
      expect(subject.config).to eq(NjiuStatus::Configuration)
    end
  end

  describe ".checks" do
    it "returns list of checks" do
      expect(NjiuStatus::Check).to receive(:all)
      subject.checks
    end
  end

  describe ".add_check" do
    let(:handler) { -> (_,_) {} }

    it "delegates to Check class" do
      expect(NjiuStatus::Check).to receive(:add).with(name: "foo", handler: handler)
      subject.add_check name: "foo", handler: handler
    end
  end
end
