class ListIdGenerator
  def initialize(store)
    @store = store
  end

  def generate_id
    token = SecureRandom.uuid

    if store.find_by_list_id(token)
      generate_id
    else
      token
    end
  end

  private

  attr_reader :store
end
