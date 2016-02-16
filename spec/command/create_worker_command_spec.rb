require 'spec_helper'
require 'command/create_worker'
require 'domain/model/worker'

class MockedRepository
  def self.find_by_name(name)
    if (name == "not unique name")
      Worker.new(1, "name", :developer)
    else
      nil
    end
  end
end

RSpec.describe Command::CreateWorker do
  describe "validation" do
    context "when given empty name" do
      let (:command) { Command::CreateWorker.new("", "developer", MockedRepository) }

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
      let (:command) { Command::CreateWorker.new("dave", "deve", MockedRepository) }

      describe "#valid?" do
        it "should return false" do
          expect(command.valid?).to be(false)
        end
      end

      describe "#errors" do
        it "should have details which is {:role=>[{:error=>:inclusion, :value=>x}]}" do
          command.validate
          expect(command.errors.details).to eq({:role=>[{:error=>:inclusion, :value=>"deve"}]})
        end
      end
    end

    context "when given conflicted name" do
      let (:command) { Command::CreateWorker.new("not unique name", "developer", MockedRepository) }

      describe "#valid?" do
        it "should return false" do
          expect(command.valid?).to be(false)
        end
      end

      describe "#errors" do
        it "should have details which is {:role=>[{:error=>:inclusion, :value=>x}]}" do
          command.validate
          expect(command.errors.details).to eq({:name =>[{:error=>:uniqueness}]})
        end
      end
    end
  end
end
