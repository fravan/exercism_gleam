import gleam/list
import gleam/result

pub type Tree(a) {
  Tree(label: a, children: List(Tree(a)))
}

pub fn from_pov(tree: Tree(a), from: a) -> Result(Tree(a), Nil) {
  tree
  |> find(target: from, path: [])
  |> result.map(fn(path) {
    let assert [targeted_tree, ..parents] = path
    reparent(targeted_tree, parents)
  })
}

fn reparent(from: Tree(a), parents: List(Tree(a))) {
  case parents {
    [] -> from
    [parent, ..rest] -> {
      Tree(
        ..from,
        children: [
          reparent(
            Tree(
              ..parent,
              children: list.filter(parent.children, fn(child) {
                child.label != from.label
              }),
            ),
            rest,
          ),
          ..from.children
        ],
      )
    }
  }
}

pub fn path_to(
  tree tree: Tree(a),
  from from: a,
  to to: a,
) -> Result(List(a), Nil) {
  tree
  |> from_pov(from)
  |> result.try(find(_, target: to, path: []))
  |> result.map(fn(path) {
    path
    |> list.map(fn(tree) { tree.label })
    |> list.reverse()
  })
}

fn find(tree: Tree(a), target label: a, path path: List(Tree(a))) {
  case tree.label == label {
    True -> Ok([tree, ..path])
    False -> list.find_map(tree.children, find(_, label, path: [tree, ..path]))
  }
}
