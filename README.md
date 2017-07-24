# Binary Search Tree

I created my own Binary Search Tree in Ruby that allows for insert, find, and delete operations to be O(log n) time. The Binary Search Tree also checks whether its balanced
and has in-order traversal.

The Binary Search Tree uses a base class BSTNode, which has a value and left/right methods.

```ruby
class BSTNode
  attr_reader :value
  attr_accessor :left, :right
  def initialize(value)
    @value = value
  end
end
```

## Insert

Inserting a node requires traversing through the tree from the root. If the inserted node's value is bigger than the root, move right; else, move left. If moving to a node's left or right child is nil, insert the node at the nil location.

Because traversing through a balanced tree takes log n time, the time complexity is O(log n). In the worst case scenario, it would take O(n) time.


## Find

Find is almost identical to Insert. You traverse down the tree right if the value you're searching for is bigger than the current node; left if it's smaller or equal. This also take O(log n) time for a balanced tree.

```ruby
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
```

## Delete

Delete is trickier than find or delete, because it requires replacing the deleted node's
spot with another node in the tree.

### Case 1: Deleted Node has no children

If the deleted node has no children, simply locate the deleted node with the find operation
and have its parent point to nil.

```ruby
if right_empty && left_empty  #must take parent and delete its pointer to deleted node
  direct_parent = parent(found_node)
  if direct_parent.value < found_node.value
    direct_parent.right = nil
  else
    direct_parent.left = nil
  end
```

### Case 2: Deleted Node has 1 child

If the deleted node has one child, the child of the deleted node must become the immediate child of the deleted node's parent.

```ruby
  elsif right_empty     #deleted node has one child
    child = found_node.left
    direct_parent = parent(found_node)
    if direct_parent.value < found_node.value
      direct_parent.right = child
    else
      direct_parent.left = child
  end
```

### Case 3: Deleted Node has 2 children

If the deleted node has two children, take the maximum of the deleted node's left branch, and use that as the replacement for the deleted node. In addition, the child of the replacement must be linked to the replacement's parent.

```ruby
  else
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
```

Delete still takes O(log n) time, because it takes O(log n) time to traverse a tree.


## Balanced?

Every time a node is inserted into a BST, it risks becoming unbalanced. A tree is balanced if its left tree and right tree's heights differ at most by 1. This definition must hold for all subtrees in the tree.

Thus, recursion is used to determine if all the subtrees are balanced. At any point, if a root node of a subtree is found to be unbalanced, the whole tree is unbalanced.

```ruby
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
```

## Tree Traversal

Tree traversal is used when all the nodes in the tree are to be gathered.
There are 3 main methods:

In-order (left, root, right)
Pre-order (root, left, right)
Post-order (left, right, root)

All methods require DFS, hence recursion. I used dynamic programming and passed
along the array holding all the nodes.


```ruby
def in_order_traversal(tree_node = @root, arr = [])
  if tree_node.nil?
    return
  end
  in_order_traversal(tree_node.left, arr)
  arr << tree_node.value      #each node's value in the tree is added
  in_order_traversal(tree_node.right, arr)
  arr
end
```

## Kth largest element

A practice problem required me to return the kth largest element: I used a reverse
in-order traversal to solve the problem:

```ruby
def kth_largest(tree_node, k, sorted_array = [])
  # return the kth largest element in the tree
  # do in order traversal, put it in array. Get the kth element in the array.
  if tree_node.nil?
    return
  end

  kth_largest(tree_node.right, k, sorted_array)

  if sorted_array.length == k
    return sorted_array.last
  end

  sorted_array.push(tree_node)

  kth_largest(tree_node.left, k, sorted_array)
end
```
