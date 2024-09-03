import gleam/bool
import gleam/float
import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/order.{Eq, Gt, Lt}
import gleam/result
import gleam/set.{type Set}

const full_price = 800.0

pub fn lowest_price(books: List(Int)) -> Float {
  let highest_price = full_price *. int.to_float(list.length(books))

  books
  |> apply_discounts(Discount(discounted_price: 0.0, children: []))
  |> sumup_discounted_price(0.0)
  |> list.fold(from: highest_price, with: fn(lowest, curr) {
    float.min(lowest, highest_price -. curr)
  })
}

type Discount {
  Discount(discounted_price: Float, children: List(Discount))
}

fn sumup_discounted_price(discount: Discount, acc: Float) -> List(Float) {
  discount.children
  |> list.flat_map(with: fn(d) {
    sumup_discounted_price(d, acc +. discount.discounted_price)
  })
}

fn apply_discounts(books: List(Int), discount: Discount) -> Discount {
  let unique_books = books |> set.from_list |> set.size

  let discounts =
    [5, 4, 3, 2]
    |> list.map(fn(discount) {
      case int.compare(discount, unique_books) {
        Lt | Eq ->
          apply_discounts(
            remove_books(discount, books, set.new(), []),
            Discount(
              discounted_price: get_discounted_price(discount),
              children: [],
            ),
          )
        Gt -> Discount(discounted_price: 0.0, children: [])
      }
    })

  Discount(..discount, children: discounts)
}

// fn apply_discounts(books: List(Int)) -> List(List(Float)) {
//   let unique_books = books |> set.from_list |> set.size

//   [5, 4, 3, 2, 1]
//   |> list.map(fn(discount) {
//     case int.compare(discount, unique_books) {
//       Lt | Eq ->
//         list.concat([
//           [get_discounted_price(discount)],
//           ..apply_discounts(remove_books(discount, books, set.new(), []))
//         ])
//       Gt -> []
//     }
//   })
// }

fn get_discounted_price(discount: Int) -> Float {
  case discount {
    5 -> 5.0 *. full_price *. 0.75
    4 -> 4.0 *. full_price *. 0.8
    3 -> 3.0 *. full_price *. 0.9
    2 -> 2.0 *. full_price *. 0.95
    _ -> full_price
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
