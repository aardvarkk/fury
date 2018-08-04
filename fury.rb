require 'pry'
require 'net/http'
require 'nokogiri'
require 'tree'

root = Tree::TreeNode.new('', nil)

def add_steps(node, steps, name)
  return if steps.empty?
  step = steps.shift

  key = step['src']
  if node[key]
    child = node[key]
  else
    child = Tree::TreeNode.new(key, steps.empty? ? name : nil)
    node << child
  end

  add_steps(child, steps, name)
end

page = Nokogiri::HTML(Net::HTTP.get(URI("http://tekkengamer.com/tekken-7/move-lists/bryan-fury")))
moves = page.css('ul.move-list li')
moves.each do |m|
  steps = m.css('img:not([data-lazy-src])')
  name  = m.css('.move-name').text
  add_steps(root, steps, name)
end

binding.pry
