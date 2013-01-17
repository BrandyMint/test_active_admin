module TestActiveAdmin
  class Config
    attr_reader :before_block, :login_block

    def before(&block)
      @before_block = block if block_given?
    end

    def login(&block)
      @login_block = block if block_given?
    end
  end
end
