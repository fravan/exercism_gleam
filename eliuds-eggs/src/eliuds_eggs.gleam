import gleam/int
import gleam/order.{Eq, Gt, Lt}

pub fn egg_count(number: Int) -> Int {
  case number {
    0 -> 0
    _ -> do_egg_count(number, read_max_bit(number, 1), 0)
  }
}

fn read_max_bit(number: Int, max_bit: Int) {
  case int.compare(number, max_bit) {
    Gt -> read_max_bit(number, max_bit * 2)
    Eq | Lt -> max_bit
  }
}

fn do_egg_count(number: Int, bit_value: Int, number_of_eggs: Int) {
  case int.compare(number, bit_value) {
    Gt -> do_egg_count(number - bit_value, bit_value / 2, number_of_eggs + 1)
    Eq -> number_of_eggs + 1
    Lt -> do_egg_count(number, bit_value / 2, number_of_eggs)
  }
}
