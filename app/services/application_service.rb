# frozen_string_literal: true

# @abstract true
class ApplicationService
  attr_reader :result

  class << self
    def run(*args, &block)
      new(*args).tap do |service|
        service.instance_variable_set(:@result, service.run(&block))
      end
    end
  end
end
