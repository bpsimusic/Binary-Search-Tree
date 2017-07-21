
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
