pub fn score(x: Float, y: Float) -> Int {
  case distance_from_origin(x, y) {
    nearest if nearest <=. 1.0 -> 10
    near if near <=. 25.0 -> 5
    outer if outer <=. 100.0 -> 1
    _ -> 0
  }
}

fn distance_from_origin(x: Float, y: Float) -> Float {
  x *. x +. y *. y
}
