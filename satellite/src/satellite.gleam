import gleam/bool
import gleam/list

pub type Tree(a) {
  Nil
  Node(value: a, left: Tree(a), right: Tree(a))
}

pub type Error {
  DifferentLengths
  DifferentItems
  NonUniqueItems
}

pub fn tree_from_traversals(
  inorder inorder: List(a),
  preorder preorder: List(a),
) -> Result(Tree(a), Error) {
  use <- bool.guard(
    when: different_lengths(inorder, preorder),
    return: Error(DifferentLengths),
  )
  use <- bool.guard(
    when: duplicates(inorder, preorder),
    return: Error(NonUniqueItems),
  )
  use <- bool.guard(
    when: different_items(inorder, preorder),
    return: Error(DifferentItems),
  )
  Ok(build_tree(preorder:, inorder:))
}

fn build_tree(preorder preorder: List(a), inorder inorder: List(a)) -> Tree(a) {
  case preorder {
    [] -> Nil
    [root, ..rest] -> {
      let assert #(left_inorder, [_root, ..right_inorder]) =
        list.split_while(inorder, fn(x) { x != root })
      let #(left_preorder, right_preorder) =
        list.split(rest, list.length(left_inorder))

      Node(
        root,
        build_tree(preorder: left_preorder, inorder: left_inorder),
        build_tree(preorder: right_preorder, inorder: right_inorder),
      )
    }
  }
}

fn different_lengths(a: List(a), b: List(a)) -> Bool {
  list.length(a) != list.length(b)
}

fn different_items(a: List(a), b: List(a)) -> Bool {
  list.any(a, fn(x) { !list.contains(b, x) })
}

fn duplicates(a: List(a), b: List(a)) -> Bool {
  list.unique(a) != a || list.unique(b) != b
}
