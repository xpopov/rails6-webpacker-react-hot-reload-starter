require 'rails_helper'

RSpec.describe "Shopify Order Race Conditions", type: :job do
  include WebhookTestHelper
  include ActiveJob::TestHelper

  before(:all) do
    # create(:scenario)
  end    

  before(:each) do
    @old_queue_adapter = ActiveJob::Base.queue_adapter
    ActiveJob::Base.queue_adapter = ActiveJob::QueueAdapters::AsyncAdapter.new \
      min_threads: 2,
      max_threads: 2 * Concurrent.processor_count,
      idletime: 1200.seconds
    Rails.configuration.enable_long_tests = true
  end

  after(:each) do
    ActiveJob::Base.queue_adapter.shutdown
    ActiveJob::Base.queue_adapter = @old_queue_adapter
  end

  after(:all) do
    DatabaseCleaner.clean_with(:truncation)
    Rails.configuration.enable_long_tests = false
  end

  let!(:new_order) {
    order = build_stubbed(:shopify_order, :with_classic)
    order
  }

  let!(:updated_order) {
    order = build_stubbed(:shopify_order, :with_classic)
    order
  }

  # bug with executor!

  # it "resolved ok even in reversed webhook sequence", disable_transactions: true do
  #   # these two lines create 4 jobs
  #   updated_order.id = new_order.id
  #   updated_order.customer = new_order.customer

  #   # puts ActiveJob::Base.queue_adapter.inspect
  #   executor = ActiveJob::Base.queue_adapter.instance_variable_get(:@scheduler).instance_variable_get(:@async_executor)

  #   expect {
  #     Shopify::OrderCreateJob.set(wait: 2.second).perform_later({shop_domain: "test.myshopify.com", order: deep_to_h(new_order)})
  #     Shopify::OrderUpdateJob.perform_later({shop_domain: "test.myshopify.com", order: deep_to_h(updated_order)})
      
  #     # puts "#{executor.completed_task_count}/#{executor.scheduled_task_count}"
  #     ActiveSupport::Dependencies.interlock.permit_concurrent_loads do
  #       sleep 6
  #     end
  #     # puts "#{executor.completed_task_count}/#{executor.scheduled_task_count}"
  #     # puts executor.inspect
  #     ActiveSupport::Dependencies.interlock.permit_concurrent_loads do
  #       with_wait(delay: 0.5) do
  #         wait_for(executor.completed_task_count).to eq 3 + 2*2 # 2 products * 2 commission default jobs
  #       end
  #     end
  #     Rails.logger.trace "Race conditions test finished: #{executor.completed_task_count}/#{executor.scheduled_task_count}"
  #   }.to change{executor.completed_task_count}.by(3)

  #   expect(Order.count).to eq 1
  # end

end