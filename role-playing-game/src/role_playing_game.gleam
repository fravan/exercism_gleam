import gleam/int
import gleam/option.{type Option, None, Some}

pub type Player {
  Player(name: Option(String), level: Int, health: Int, mana: Option(Int))
}

pub fn introduce(player: Player) -> String {
  case player.name {
    None -> "Mighty Magician"
    Some(name) -> name
  }
}

pub fn revive(player: Player) -> Option(Player) {
  let alive = player.health > 0
  let high_level = player.level >= 10

  case alive, high_level {
    True, _ -> None
    _, True -> Some(Player(..player, health: 100, mana: Some(100)))
    _, _ -> Some(Player(..player, health: 100))
  }
}

pub fn cast_spell(player: Player, cost: Int) -> #(Player, Int) {
  let mana_pool = case player.mana {
    None -> -1
    Some(m) -> m
  }

  case mana_pool {
    -1 -> #(Player(..player, health: int.max(0, player.health - cost)), 0)
    m if m >= cost -> #(Player(..player, mana: Some(m - cost)), cost * 2)
    _ -> #(player, 0)
  }
}
