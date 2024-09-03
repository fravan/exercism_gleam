import gleam/list
import gleam/result
import gleam/string

pub fn first_letter(name: String) -> String {
  name
  |> string.trim()
  |> string.first()
  |> result.unwrap("")
}

pub fn initial(name: String) -> String {
  name
  |> first_letter()
  |> string.uppercase()
  |> string.append(".")
}

pub fn initials(full_name: String) -> String {
  full_name
  |> string.split(on: " ")
  |> list.map(with: initial)
  |> string.join(" ")
}

pub fn pair(full_name1: String, full_name2: String) {
  //      ******       ******
  //    **      **   **      **
  //  **         ** **         **
  // **            *            **
  // **                         **
  // **     X. X.  +  X. X.     **
  //  **                       **
  //    **                   **
  //      **               **
  //        **           **
  //          **       **
  //            **   **
  //              ***
  //               *
  "\n"
  |> string.append("     ******       ******\n")
  |> string.append("   **      **   **      **\n")
  |> string.append(" **         ** **         **\n")
  |> string.append("**            *            **\n")
  |> string.append("**                         **\n")
  |> string.append(
    "**     "
    <> initials(full_name1)
    <> "  +  "
    <> initials(full_name2)
    <> "     **\n",
  )
  |> string.append(" **                       **\n")
  |> string.append("   **                   **\n")
  |> string.append("     **               **\n")
  |> string.append("       **           **\n")
  |> string.append("         **       **\n")
  |> string.append("           **   **\n")
  |> string.append("             ***\n")
  |> string.append("              *\n")
}
