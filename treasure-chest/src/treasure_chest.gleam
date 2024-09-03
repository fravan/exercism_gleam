pub type TreasureChest(a) {
  TreasureChest(password: String, treasure: a)
}

pub type UnlockResult(a) {
  Unlocked(treasure: a)
  WrongPassword
}

pub fn get_treasure(
  chest: TreasureChest(treasure),
  password: String,
) -> UnlockResult(treasure) {
  case chest {
    TreasureChest(treasure:, password: pwd) if pwd == password ->
      Unlocked(treasure)
    _ -> WrongPassword
  }
}
