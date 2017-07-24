require 'bst_node'
require 'byebug'

class BinarySearchTree
  attr_accessor :root

  def initialize
    @root = nil
  end

  #insert takes O(log n) time.
  def insert(value)
    if root.nil?
      self.root= BSTNode.new(value)   #if root doesn't exist
    else
      root = self.root
      while(root)
        if value > root.value
          if root.right.nil?
            new_node = BSTNode.new(value)
            root.right = new_node
            root = root.right
            return root.right #return the newly added node
          else
            root = root.right #traverse
          end
        else
          if root.left.nil?
            new_node = BSTNode.new(value)
            root.left = new_node
            return root.left  #return the newly added node
          else
            root = root.left #traverse
          end
        end
      end
    end
    root
  end

  #Find takes O(log n) time
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


  #Delete takes O(log n) time
  def delete(value)
    found_node = self.find(value)
    return nil if found_node.nil?

    if found_node == root
      self.root = nil
      return found_node
    end

    #first case, deleted node has no children
    right_empty = found_node.right.nil?
    left_empty = found_node.left.nil?

    if right_empty && left_empty  #must take parent and delete its pointer to deleted node
      direct_parent = parent(found_node)
      if direct_parent.value < found_node.value
        direct_parent.right = nil
      else
        direct_parent.left = nil
      end
    elsif right_empty     #deleted node has one child
      child = found_node.left
      direct_parent = parent(found_node)
      if direct_parent.value < found_node.value
        direct_parent.right = child
      else
        direct_parent.left = child
      end
    elsif left_empty      #deleted node has one child
      child = found_node.right
      direct_parent = parent(found_node)
      if direct_parent.value < found_node.value
        direct_parent.right = child
      else
        direct_parent.left = child
      end
    else     #deleted node has two children. I'm choosing the left side maximum
            #of the deleted node for a replacement.

      left_child = found_node.left
      right_child = found_node.right
      max = maximum(left_child)
      child_of_max = max.left   #max's child will always be on the left!!!
      parent_of_max = parent(max)
      parent_of_deleted = parent(found_node)

      if parent_of_deleted.value < found_node.value
        parent_of_deleted.right = max
      else
        parent_of_deleted.left = max
      end

      parent_of_max.right = child_of_max  #reconnecting the holes caused by extracting max
      max.left = left_child  #replacing the deleted node with the max
      max.right = right_child  #replacing the deleted node with the max
    end

    found_node
  end

  def maximum(tree_node = @root)
    current_node = tree_node
    while(current_node)
      return current_node if current_node.right.nil?
      current_node = current_node.right
    end
  end

  def height(tree_node = @root)
    return -1 if tree_node.nil?
    [height(tree_node.left), height(tree_node.right)].max + 1
    #DFS. height gives you the height of the tree from the root
    #to the farthest leaf.
  end

  def is_balanced?(tree_node = @root)
    if tree_node.nil?
      return true
    end

    left_height = height(tree_node.left)
    right_height = height(tree_node.right)

    #if heights differ more than 1, not balanced.
    if ((left_height-right_height).abs >1)
      return false
    end

    left_bool = is_balanced?(tree_node.left)
    right_bool = is_balanced?(tree_node.right)

    #the overall tree is only balanced if both subtrees are balanced.
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
    arr << tree_node.value      #each node's value in the tree is added
    in_order_traversal(tree_node.right, arr)
    arr
  end


  private
  #find the parent of a node
  def parent(node)
    value = node.value
    parent_node = nil
    current_node = @root
    while (current_node)
      if value > current_node.value
        parent_node = current_node  #always keep a pointer to the parent
                                    #before traversing down
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
