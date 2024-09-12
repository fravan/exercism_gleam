import gleam/bool
import gleam/dict.{type Dict}
import gleam/list
import gleam/pair

pub opaque type Set(t) {
  Set(items: Dict(t, t))
}

pub fn new(members: List(t)) -> Set(t) {
  dict.new()
  |> list.fold(
    members,
    from: _,
    with: fn(d, member) { dict.insert(d, member, member) },
  )
  |> Set
}

pub fn is_empty(set: Set(t)) -> Bool {
  set.items |> dict.is_empty
}

pub fn contains(in set: Set(t), this member: t) -> Bool {
  set.items |> dict.has_key(member)
}

pub fn is_subset(first: Set(t), of second: Set(t)) -> Bool {
  dict.to_list(first.items)
  |> list.map(pair.first)
  |> list.all(fn(v) { dict.has_key(second.items, v) })
}

pub fn disjoint(first: Set(t), second: Set(t)) -> Bool {
  dict.to_list(first.items)
  |> list.map(pair.first)
  |> list.any(fn(v) { dict.has_key(second.items, v) })
  |> bool.negate
}

pub fn is_equal(first: Set(t), to second: Set(t)) -> Bool {
  first.items == second.items
}

pub fn add(to set: Set(t), this member: t) -> Set(t) {
  set.items
  |> dict.insert(member, member)
  |> Set
}

pub fn intersection(of first: Set(t), and second: Set(t)) -> Set(t) {
  first.items
  |> dict.filter(fn(_, a) { dict.has_key(second.items, a) })
  |> Set
}

pub fn difference(between first: Set(t), and second: Set(t)) -> Set(t) {
  first.items
  |> dict.filter(fn(_, a) { !dict.has_key(second.items, a) })
  |> Set
}

pub fn union(of first: Set(t), and second: Set(t)) -> Set(t) {
  dict.merge(first.items, second.items) |> Set
}
