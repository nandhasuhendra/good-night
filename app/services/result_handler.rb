module ResultHandler
  private

  ResultSuccess = Struct.new(:success?, :failure?, :result)
  ResultFailure = Struct.new(:success?, :failure?, :result)

  def handler_success(result)
    ResultSuccess.new(true, false, result)
  end

  def handler_failure(result)
    ResultFailure.new(false, true, result)
  end
end
