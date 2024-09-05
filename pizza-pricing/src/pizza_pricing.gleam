import gleam/list

pub type Pizza {
  Margherita
  Caprese
  Formaggio
  ExtraSauce(Pizza)
  ExtraToppings(Pizza)
}

pub fn pizza_price(pizza: Pizza) -> Int {
  do_pizza_price(pizza, 0)
}

fn do_pizza_price(pizza: Pizza, acc: Int) {
  case pizza {
    Margherita -> 7 + acc
    Caprese -> 9 + acc
    Formaggio -> 10 + acc
    ExtraSauce(wrap) -> do_pizza_price(wrap, 1 + acc)
    ExtraToppings(wrap) -> do_pizza_price(wrap, 2 + acc)
  }
}

pub fn order_price(order: List(Pizza)) -> Int {
  let fee = case list.length(order) {
    2 -> 2
    1 -> 3
    _ -> 0
  }

  fee
  + list.fold(order, from: 0, with: fn(acc, pizza) { acc + pizza_price(pizza) })
}
