require 'spec_helper'
require 'command/create_worker'

RSpec.describe Command::CreateWorker do
  describe "validation" do
    context "when given empty name" do
      let (:command) { Command::CreateWorker.new("", 1) }

      describe "#valid?" do
        it "should return false" do
          expect(command.valid?).to be(false)
        end
      end

      describe "#errors" do
        it "should have details which is {:name => [{:error=>:blank}]}" do
          command.validate
          expect(command.errors.details).to eq({:name => [{:error=>:blank}]})
        end
      end
    end

    context "when given invalid role" do
      let (:command) { Command::CreateWorker.new("dave", 0) }

      describe "#valid?" do
        it "should return false" do
          expect(command.valid?).to be(false)
        end
      end

      describe "#errors" do
        it "should have details which is {:role=>[{:error=>:inclusion, :value=>x}]}" do
          command.validate
          expect(command.errors.details).to eq({:role=>[{:error=>:inclusion, :value=>0}]})
        end
      end
    end
  end
end
