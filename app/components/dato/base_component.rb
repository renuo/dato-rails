module Dato
  class BaseComponent < ViewComponent::Base
    attr_reader :data

    def initialize(data)
      @data = data
    end
  end
end
