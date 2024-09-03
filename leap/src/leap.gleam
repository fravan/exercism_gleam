pub fn is_leap_year(year: Int) -> Bool {
  let evenly_4 = year % 4 == 0
  let evenly_100 = year % 100 == 0
  let evenly_400 = year % 400 == 0

  evenly_4 && { !evenly_100 || evenly_400 }
}
