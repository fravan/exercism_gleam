import gleam/set.{type Set}
import gleam/string

pub fn new_collection(card: String) -> Set(String) {
  set.from_list([card])
}

pub fn add_card(collection: Set(String), card: String) -> #(Bool, Set(String)) {
  #(set.contains(collection, card), set.insert(collection, card))
}

pub fn trade_card(
  my_card: String,
  their_card: String,
  collection: Set(String),
) -> #(Bool, Set(String)) {
  #(
    set.contains(collection, my_card) && !set.contains(collection, their_card),
    collection |> set.delete(my_card) |> set.insert(their_card),
  )
}

pub fn boring_cards(collections: List(Set(String))) -> List(String) {
  case collections {
    [] -> []
    [first, ..rest] -> do_boring_cards(rest, first) |> set.to_list
  }
}

fn do_boring_cards(collections: List(Set(String)), acc: Set(String)) {
  case collections {
    [] -> acc
    [first, ..rest] -> do_boring_cards(rest, set.intersection(acc, first))
  }
}

pub fn total_cards(collections: List(Set(String))) -> Int {
  do_total_cards(collections, set.new()) |> set.size
}

fn do_total_cards(collections: List(Set(String)), acc: Set(String)) {
  case collections {
    [] -> acc
    [first, ..rest] -> do_total_cards(rest, set.union(acc, first))
  }
}

pub fn shiny_cards(collection: Set(String)) -> Set(String) {
  set.filter(collection, fn(s) { string.starts_with(s, "Shiny ") })
}
