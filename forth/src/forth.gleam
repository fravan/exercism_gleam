import gleam/bool
import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/option.{None, Some}
import gleam/regex.{Match}
import gleam/result
import gleam/string

type Operation =
  fn(List(Int)) -> Result(List(Int), ForthError)

/// The idea is:
/// The stack is what is saved and printed back to the user
/// Every time we have an operator, we trigger an operation, giving it the stack to work on
pub opaque type Forth {
  Forth(
    stack: List(Int),
    operations: Dict(String, Operation),
    customs: Dict(String, String),
  )
}

pub type ForthError {
  DivisionByZero
  StackUnderflow
  InvalidWord
  UnknownWord
}

pub fn new() -> Forth {
  let operations =
    dict.new()
    |> add_operation_2("+", fn(a, b, rest) { Ok([a + b, ..rest]) })
    |> add_operation_2("-", fn(a, b, rest) { Ok([a - b, ..rest]) })
    |> add_operation_2("*", fn(a, b, rest) { Ok([a * b, ..rest]) })
    |> add_operation_2("/", fn(a, b, rest) {
      use <- bool.guard(when: b == 0, return: Error(DivisionByZero))
      Ok([a / b, ..rest])
    })
    |> add_operation_1("DUP", fn(a, rest) { Ok([a, a, ..rest]) })
    |> add_operation_1("DROP", fn(_, rest) { Ok(rest) })
    |> add_operation_2("SWAP", fn(a, b, rest) { Ok([a, b, ..rest]) })
    |> add_operation_2("OVER", fn(a, b, rest) { Ok([a, b, a, ..rest]) })
  Forth([], operations:, customs: dict.new())
}

fn add_operation_1(
  d: Dict(String, Operation),
  name: String,
  operation: fn(Int, List(Int)) -> Result(List(Int), ForthError),
) {
  dict.insert(d, name, fn(stack) {
    case stack {
      [] -> Error(StackUnderflow)
      [a, ..rest] -> operation(a, rest)
    }
  })
}

fn add_operation_2(
  d: Dict(String, Operation),
  name: String,
  operation: fn(Int, Int, List(Int)) -> Result(List(Int), ForthError),
) {
  dict.insert(d, name, fn(stack) {
    case stack {
      [] | [_] -> Error(StackUnderflow)
      [a, b, ..rest] -> operation(b, a, rest)
    }
  })
}

pub fn format_stack(f: Forth) -> String {
  f.stack
  |> list.map(int.to_string)
  |> list.reverse()
  |> string.join(" ")
}

pub fn eval(f: Forth, prog: String) -> Result(Forth, ForthError) {
  let prog = string.uppercase(prog)
  case check_for_custom_definition(prog) {
    Some(word_def) -> eval_new_word(f, word_def.0, word_def.1)
    None -> eval_basic(f, prog)
  }
}

fn check_for_custom_definition(input: String) {
  let assert Ok(word_definition_regex) = regex.from_string("^: (.*?) (.*) ;$")
  case regex.scan(with: word_definition_regex, content: input) {
    [Match(_, submatches: [Some(word_name), Some(definition)])] ->
      Some(#(word_name, definition))
    _ -> None
  }
}

/// When saving a custom word:
/// - we make sure it is not named as an int
/// - we "flatten" the custom definition by replacing inner custom words by their definition
///   meaning ": foo bar 2 ;" with a definition for bar such as ": bar 3 ;" will save the final definition
///   as ": foo 3 2 ;"
fn eval_new_word(
  f: Forth,
  word_name: String,
  definition: String,
) -> Result(Forth, ForthError) {
  case int.parse(word_name) {
    Ok(_) -> Error(InvalidWord)
    _ -> {
      definition
      |> string.split(" ")
      |> list.flat_map(replace_customs(_, f))
      |> string.join(" ")
      |> fn(result) {
        Forth(..f, customs: dict.insert(f.customs, word_name, result))
      }
      |> Ok
    }
  }
}

/// When evaluating the input
/// - We first need to flatten custom definition, same as above
/// - Then, for every part:
/// - If it's an int, save it to the stack
/// - Otherwise (the `try_recover` part), get the wanted operation and apply it on the stack,
///   giving a new stack to work with
/// Loop over every part until it is done or we hit an error.
fn eval_basic(f: Forth, prog: String) -> Result(Forth, ForthError) {
  prog
  |> string.split(" ")
  |> list.flat_map(replace_customs(_, f))
  |> list.try_fold(from: f, with: fn(f, current) {
    current
    |> int.parse
    |> result.map(fn(number) { Forth(..f, stack: [number, ..f.stack]) })
    |> result.try_recover(fn(_) {
      f.operations
      |> dict.get(current)
      |> result.map_error(fn(_) { UnknownWord })
      |> result.try(fn(operation) { operation(f.stack) })
      |> result.map(fn(stack) { Forth(..f, stack:) })
    })
  })
}

fn replace_customs(input: String, f: Forth) -> List(String) {
  case dict.get(f.customs, input) {
    Ok(custom) -> custom |> string.split(" ")
    _ -> [input]
  }
}
