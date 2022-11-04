class Graph
  attr_accessor :nodes

  def initialize
    @nodes = []
  end

  def add_node(id)
    return if visited?(id)

    new_node = Node.new(id)
    @nodes << new_node
    new_node
  end

  def visited?(id)
    @nodes.find { |node| node.id == id }
  end

  def most_vertices
    count = {}
    @nodes.each do |node|
      node.children.each { |child| count[child.id] ? count[child.id] += 1 : count[child.id] = 0 }
    end
    count.max_by { |_id, vertices| vertices }[0]
  end
end
