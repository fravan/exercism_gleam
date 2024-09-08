import gleam/list
import gleam/result

pub type Tree(a) {
  Leaf
  Node(value: a, left: Tree(a), right: Tree(a))
}

type Direction {
  Left
  Right
}

pub opaque type Zipper(a) {
  Zipper(tree: Tree(a), directions: List(Direction))
}

pub fn to_zipper(tree: Tree(a)) -> Zipper(a) {
  Zipper(tree, [])
}

pub fn to_tree(zipper: Zipper(a)) -> Tree(a) {
  zipper.tree
}

pub fn value(zipper: Zipper(a)) -> Result(a, Nil) {
  case read_focus(zipper) {
    Ok(Node(value, _, _)) -> Ok(value)
    _ -> Error(Nil)
  }
}

pub fn up(zipper: Zipper(a)) -> Result(Zipper(a), Nil) {
  case zipper.directions {
    [] -> Error(Nil)
    [_, ..rest] -> Ok(Zipper(..zipper, directions: rest))
  }
}

pub fn left(zipper: Zipper(a)) -> Result(Zipper(a), Nil) {
  case read_focus(zipper) {
    Ok(Node(_, _, _)) ->
      Ok(Zipper(..zipper, directions: [Left, ..zipper.directions]))
    _ -> Error(Nil)
  }
}

pub fn right(zipper: Zipper(a)) -> Result(Zipper(a), Nil) {
  case read_focus(zipper) {
    Ok(Node(_, _, _)) ->
      Ok(Zipper(..zipper, directions: [Right, ..zipper.directions]))
    _ -> Error(Nil)
  }
}

pub fn set_value(zipper: Zipper(a), value: a) -> Zipper(a) {
  zipper
  |> with_new_focus(fn(focus) {
    case focus {
      Leaf -> Ok(Node(value, Leaf, Leaf))
      Node(_, left, right) -> Ok(Node(value, left, right))
    }
  })
  |> result.unwrap_both
}

pub fn set_left(zipper: Zipper(a), tree: Tree(a)) -> Result(Zipper(a), Nil) {
  zipper
  |> with_new_focus(fn(focus) {
    case focus {
      Leaf -> Error(Nil)
      Node(value, _, right) -> Ok(Node(value, tree, right))
    }
  })
  |> result.nil_error
}

pub fn set_right(zipper: Zipper(a), tree: Tree(a)) -> Result(Zipper(a), Nil) {
  zipper
  |> with_new_focus(fn(focus) {
    case focus {
      Leaf -> Error(Nil)
      Node(value, left, _) -> Ok(Node(value, left, tree))
    }
  })
  |> result.nil_error
}

fn with_new_focus(
  zipper: Zipper(a),
  focus_update: fn(Tree(a)) -> Result(Tree(a), Nil),
) {
  case tree_update(zipper.tree, focus_update, list.reverse(zipper.directions)) {
    Ok(tree) -> Ok(Zipper(..zipper, tree:))
    Error(_) -> Error(zipper)
  }
}

fn tree_update(
  tree: Tree(a),
  focus_update: fn(Tree(a)) -> Result(Tree(a), Nil),
  directions: List(Direction),
) {
  case tree, directions {
    _, [] -> focus_update(tree)
    Leaf, [_, ..] -> panic
    Node(x, left, right), [Left, ..rest] -> {
      case tree_update(left, focus_update, rest) {
        Ok(left) -> Ok(Node(x, left, right))
        Error(_) -> Error(Nil)
      }
    }
    Node(x, left, right), [Right, ..rest] -> {
      case tree_update(right, focus_update, rest) {
        Ok(right) -> Ok(Node(x, left, right))
        Error(_) -> Error(Nil)
      }
    }
  }
}

fn read_focus(zipper: Zipper(a)) {
  do_read_focus(zipper.tree, list.reverse(zipper.directions))
}

fn do_read_focus(
  tree: Tree(a),
  directions: List(Direction),
) -> Result(Tree(a), Nil) {
  case tree, directions {
    _, [] -> Ok(tree)
    Leaf, [_, ..] -> Error(Nil)
    Node(_, left, _), [Left, ..rest] -> do_read_focus(left, rest)
    Node(_, _, right), [Right, ..rest] -> do_read_focus(right, rest)
  }
}
