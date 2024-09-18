import gleam/list

pub type NestedList(a) {
  Null
  Value(a)
  List(List(NestedList(a)))
}

pub fn flatten(nested_list: NestedList(a)) -> List(a) {
  case nested_list {
    Null -> []
    Value(val) -> [val]
    List(nested_values) -> list.flat_map(nested_values, flatten)
  }
}
