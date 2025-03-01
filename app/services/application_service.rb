class ApplicationService
  include ResultHandler
  include ErrorMessages

  def self.call(*args)
    new(*args).call
  end
end
