import gleam/int
import gleam/order.{Eq, Gt, Lt}
import gleam/queue.{type Queue}
import gleam/result

pub opaque type CircularBuffer(t) {
  CircularBuffer(capacity: Int, queue: Queue(t))
}

pub fn new(capacity: Int) -> CircularBuffer(t) {
  from_queue(capacity, queue.new())
}

fn from_queue(capacity: Int, queue: Queue(t)) -> CircularBuffer(t) {
  CircularBuffer(capacity, queue)
}

pub fn read(buffer: CircularBuffer(t)) -> Result(#(t, CircularBuffer(t)), Nil) {
  buffer.queue
  |> queue.pop_back
  |> result.map(fn(tuple) {
    let #(read, queue) = tuple
    #(read, from_queue(buffer.capacity, queue))
  })
}

pub fn write(
  buffer: CircularBuffer(t),
  item: t,
) -> Result(CircularBuffer(t), Nil) {
  case int.compare(queue.length(buffer.queue), buffer.capacity) {
    Gt | Eq -> Error(Nil)
    Lt -> Ok(from_queue(buffer.capacity, queue.push_front(buffer.queue, item)))
  }
}

pub fn overwrite(buffer: CircularBuffer(t), item: t) -> CircularBuffer(t) {
  case int.compare(queue.length(buffer.queue), buffer.capacity) {
    Gt | Eq -> {
      let assert Ok(#(_, q)) = queue.pop_back(buffer.queue)
      from_queue(buffer.capacity, queue.push_front(q, item))
    }
    Lt -> from_queue(buffer.capacity, queue.push_front(buffer.queue, item))
  }
}

pub fn clear(buffer: CircularBuffer(t)) -> CircularBuffer(t) {
  new(buffer.capacity)
}
