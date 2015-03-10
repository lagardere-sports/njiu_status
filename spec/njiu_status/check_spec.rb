require "spec_helper"

RSpec.describe NjiuStatus::Check do
  subject { NjiuStatus::Check }

  describe ".all" do
    it "is initialized with empty hash" do
      expect(subject.all).to eq({})
    end
  end

  describe ".add" do
    let(:handler) { ->(_,_){} }

    before { subject.add(name: "foo", handler: handler) }

    it "adds slash to name" do
      expect(subject.all.keys).to eq(["/foo"])
    end

    it "assigns handler" do
      expect(subject.all.values).to eq([handler])
    end
  end
end
