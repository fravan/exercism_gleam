import gleam/string

// Please define the TreasureChest type
pub opaque type TreasureChest(a) {
  TreasureChest(treasure: a, password: String)
}

pub fn create(
  password: String,
  contents: treasure,
) -> Result(TreasureChest(treasure), String) {
  case string.length(password) < 8 {
    True -> Error("Password must be at least 8 characters long")
    False -> Ok(TreasureChest(contents, password))
  }
}

pub fn open(
  chest: TreasureChest(treasure),
  password: String,
) -> Result(treasure, String) {
  case password == chest.password {
    True -> Ok(chest.treasure)
    False -> Error("Incorrect password")
  }
}
