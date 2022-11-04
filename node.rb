class Node
  # the challenge calls them "children" which is more appropriate for trees
  attr_reader :id
  attr_accessor :children

  def initialize(id)
    @id = id
    @children = []
  end

  def add_child(child)
    @children << child
    child
  end
end
