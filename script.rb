#!/usr/bin/env ruby

require 'net/http'
require 'json'

require_relative 'graph'
require_relative 'node'

NODES_URL = 'https://nodes-on-nodes-challenge.herokuapp.com/nodes/'.freeze
STARTING_NODE_ID = '089ef556-dfff-4ff2-9733-654645be56fe'.freeze

def get_nodes(ids)
  uri = URI(NODES_URL + ids.join(','))
  res = Net::HTTP.get_response(uri)
  JSON.parse(res.body)
end

def create_nodes(graph, node_id, child_node_ids)
  return if graph.visited?(node_id)

  new_node = graph.add_node(node_id)
  child_node_ids.map { |id| new_node.add_child(Node.new(id)) }
end

def get_child_nodes(graph, node_hashes)
  node_hashes.map { |hash| create_nodes(graph, hash['id'], hash['child_node_ids']) }.flatten
end

def traverse
  graph = Graph.new
  starting_node_hashes = get_nodes([STARTING_NODE_ID])
  child_nodes = get_child_nodes(graph, starting_node_hashes)

  until child_nodes.empty?
    child_node_hashes = get_nodes(child_nodes.compact.map(&:id))
    child_nodes = get_child_nodes(graph, child_node_hashes)
  end

  puts "Found #{graph.nodes.length} nodes."
  puts "'#{graph.most_vertices}' has the most edges." # the challenge uses the word "common"
end

traverse
