import gleam/bool
import gleam/float
import gleam/function
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/order.{Eq, Gt, Lt}
import gleam/result
import gleam/set.{type Set}

const full_price = 800.0

pub fn lowest_price(books: List(Int)) -> Float {
  let highest_price = full_price *. int.to_float(list.length(books))

  Node(books:, discount_price: 0.0, d5: None, d4: None, d3: None, d2: None)
  |> apply_discounts
  |> function.tap(io.debug)
  |> get_node_discount_branches()
  |> list.fold(from: highest_price, with: fn(lowest, total_discounted) {
    float.min(lowest, highest_price -. total_discounted)
  })
}

fn get_node_discount_branches(node: Node) {
  case
    [node.d5, node.d4, node.d3, node.d2]
    |> option.values
  {
    [] -> [0.0]
    otherwise ->
      otherwise
      |> list.flat_map(fn(node) {
        get_node_discount_branches(node)
        |> list.map(fn(discount) { discount +. node.discount_price })
      })
  }
}

type Node {
  Node(
    books: List(Int),
    discount_price: Float,
    d5: Option(Node),
    d4: Option(Node),
    d3: Option(Node),
    d2: Option(Node),
  )
}

fn apply_discounts(node: Node) -> Node {
  let unique_books = node.books |> set.from_list |> set.size

  Node(
    ..node,
    d5: try_apply_discount(5, unique_books, node.books),
    d4: try_apply_discount(4, unique_books, node.books),
    d3: try_apply_discount(3, unique_books, node.books),
    d2: try_apply_discount(2, unique_books, node.books),
  )
}

fn try_apply_discount(
  required_unique_books: Int,
  remaining_unique_books: Int,
  books: List(Int),
) {
  case int.compare(required_unique_books, remaining_unique_books) {
    Lt | Eq ->
      Some(
        apply_discounts(Node(
          books: remove_books(required_unique_books, books, set.new(), []),
          discount_price: get_discounted_price(required_unique_books),
          d5: None,
          d4: None,
          d3: None,
          d2: None,
        )),
      )
    Gt -> None
  }
}

fn get_discounted_price(discount: Int) -> Float {
  case discount {
    5 -> 5.0 *. full_price *. 0.25
    4 -> 4.0 *. full_price *. 0.2
    3 -> 3.0 *. full_price *. 0.1
    2 -> 2.0 *. full_price *. 0.05
    _ -> 0.0
  }
}

fn remove_books(
  discount: Int,
  books: List(Int),
  books_removed: Set(Int),
  acc: List(Int),
) {
  use <- bool.lazy_guard(
    when: discount == set.size(books_removed),
    return: fn() { list.concat([books, acc]) },
  )

  case books {
    [] -> panic as "Need to remove books but there's none left"
    [first, ..rest] -> {
      case set.contains(books_removed, first) {
        True -> remove_books(discount, rest, books_removed, [first, ..acc])
        False ->
          remove_books(discount, rest, set.insert(books_removed, first), acc)
      }
    }
  }
}
