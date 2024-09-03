import gleam/list

pub type Tree {
  Nil
  Node(data: Int, left: Tree, right: Tree)
}

pub fn to_tree(data: List(Int)) -> Tree {
  data
  |> list.fold(from: Nil, with: insert_in_tree)
}

pub fn sorted_data(data: List(Int)) -> List(Int) {
  to_tree(data)
  |> to_list()
}

fn insert_in_tree(tree: Tree, data: Int) -> Tree {
  case tree {
    Nil -> Node(data, Nil, Nil)
    Node(x, left, right) if data <= x ->
      Node(x, insert_in_tree(left, data), right)
    Node(x, left, right) -> Node(x, left, insert_in_tree(right, data))
  }
}

fn to_list(tree: Tree) -> List(Int) {
  case tree {
    Nil -> []
    Node(x, left, right) -> list.concat([to_list(left), [x], to_list(right)])
  }
}
