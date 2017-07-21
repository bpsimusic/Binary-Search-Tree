require 'bst_node'
require 'byebug'

class BinarySearchTree
  attr_accessor :root

  def initialize
    @root = nil
  end

  def insert(value)
    if root.nil?
      self.root= BSTNode.new(value)
    else
      root = self.root
      while(root)
        if value > root.value
          if root.right.nil?
            new_node = BSTNode.new(value)
            root.right = new_node
            root = root.right
            break
          else
          root = root.right
          end
        else
          if root.left.nil?
            new_node = BSTNode.new(value)
            root.left = new_node
            root = root.left
            break
          else
          root = root.left
          end
        end
      end
    end
    root
  end

  def find(value, tree_node = @root)
    current_node = tree_node
    while (current_node)
      if value > current_node.value
        current_node = current_node.right
      elsif value < current_node.value
        current_node = current_node.left
      else
        return current_node
      end
    end

    nil
  end

  def delete(value)
    found_node = self.find(value)
    return nil if found_node.nil?

    if found_node == root
      self.root = nil
      return found_node
    end

    right_empty = found_node.right.nil?
    left_empty = found_node.left.nil?
    if right_empty && left_empty
      dad = parent(found_node)
      if dad.value < found_node.value
        dad.right = nil
      else
        dad.left = nil
      end
    elsif right_empty
      child = found_node.left
      dad = parent(found_node)
      if dad.value < found_node.value
        dad.right = child
      else
        dad.left = child
      end
    elsif left_empty
      child = found_node.right
      dad = parent(found_node)
      if dad.value < found_node.value
        dad.right = child
      else
        dad.left = child
      end
    else
      #has two children. I'm choosing the left side.
      left_child = found_node.left
      right_child = found_node.right
      max = maximum(left_child)
      child_of_max = max.left
      parent_of_max = parent(max)
      parent_of_deleted = parent(found_node)

      if parent_of_deleted.value < found_node.value
        parent_of_deleted.right = max
      else
        parent_of_deleted.left = max
      end

      parent_of_max.right = child_of_max
      max.left = left_child  #replacing the deleted node
      max.right = right_child  #replacing the deleted node
    end

    found_node
  end

  # helper method for #delete:
  def maximum(tree_node = @root)
    current_node = tree_node
    while(current_node)
      return current_node if current_node.right.nil?
      current_node = current_node.right
    end
  end

  def depth(tree_node = @root)
    return -1 if tree_node.nil?
    [depth(tree_node.left), depth(tree_node.right)].max + 1
    #DFS. depth is the number of edges starting from the root of the tree
  end

  def is_balanced?(tree_node = @root)
    if tree_node.nil?
      return true
    end

    left_height = depth(tree_node.left)
    right_height = depth(tree_node.right)

    if ((left_height-right_height).abs >1)
      return false
    end

    left_bool = is_balanced?(tree_node.left)
    right_bool = is_balanced?(tree_node.right)

    if (left_bool && right_bool)
      return true
    else
      return false
    end
  end

  def in_order_traversal(tree_node = @root, arr = [])
    if tree_node.nil?
      return
    end
    in_order_traversal(tree_node.left, arr)
    arr << tree_node.value
    in_order_traversal(tree_node.right, arr)
    arr
  end


  private
  # optional helper methods go here:
  def parent(node)
    value = node.value
    parent_node = nil
    current_node = @root
    while (current_node)
      if value > current_node.value
        parent_node = current_node
        current_node = current_node.right
      elsif value < current_node.value
        parent_node = current_node
        current_node = current_node.left
      else
        return parent_node
      end
    end

    nil

  end

end
