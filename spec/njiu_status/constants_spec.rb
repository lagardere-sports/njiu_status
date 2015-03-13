require "spec_helper"

RSpec.describe "Constants" do
  describe "nagios plugin exit codes" do
    it "EXIT_OK returns 0" do
      expect(NjiuStatus::EXIT_OK).to eq(0)
    end

    it "EXIT_WARNING returns 1" do
      expect(NjiuStatus::EXIT_WARNING).to eq(1)
    end

    it "EXIT_CRITICAL returns 2" do
      expect(NjiuStatus::EXIT_CRITICAL).to eq(2)
    end

    it "EXIT_UNKNOWN returns 3" do
      expect(NjiuStatus::EXIT_UNKNOWN).to eq(3)
    end
  end
end
