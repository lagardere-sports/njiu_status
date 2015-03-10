require "spec_helper"

RSpec.describe NjiuStatus::Configuration do
  subject { NjiuStatus::Configuration }

  describe ".token" do
    it "can be set" do
      subject.token = "foobar123"
      expect(subject.token).to eq("foobar123")
    end
  end
end
