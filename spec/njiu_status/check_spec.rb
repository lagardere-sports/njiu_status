require "spec_helper"

RSpec.describe NjiuStatus::Check do
  subject { NjiuStatus::Check }

  before { subject.clear }

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

  describe ".clear" do
    it "empties list of checks" do
      subject.add(name: "foo", handler: nil)
      expect {
        subject.clear
      }.to change { subject.all.length}.from(1).to(0)
    end
  end
end
