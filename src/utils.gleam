import gleam/result
import gleam/string
import file_streams/file_stream
import gleam/list
import gleam/option.{None, Some}

fn read_lines_loop(stream: file_stream.FileStream, callback: fn(String) -> value, acc: List(value)) -> List(value) {
    case file_stream.read_line(stream) {
        Ok(line) -> {
            read_lines_loop(stream, callback, [callback(string.replace(line, "\n", "")), ..acc])
        }
        _ -> {
            let _ = file_stream.close(stream)

            acc
        }
    }
}

pub fn read_lines(file_name: String, callback: fn(String) -> value) -> List(value) {
    let assert Ok(stream) = file_stream.open_read(file_name)

    read_lines_loop(stream, callback, [])
}

pub fn remove_index(row: List(Int), index: Int) -> List(Int) {
    list.take(row, index)
        |> list.append(list.drop(row, index + 1))
}

pub fn get_index(arr: List(value), index: Int) -> value {
    let assert [item, .._] = list.drop(arr, index)

    item
}

pub fn get_index_safe(arr: List(value), index: Int) -> option.Option(value) {
    case list.drop(arr, index), index {
        [item, .._], _ if index >= 0 -> Some(item)
        _, _ -> None
    }
}

pub fn find_index(arr: List(value), value: value) -> Int {
    let #(index, _) = list.index_map(arr, fn (item, index) { #(index, item) })
        |> list.find(fn (curr) {
            let #(_, item) = curr

            item == value
        })
        |> result.unwrap(#(-1, value))
    
    index
}
