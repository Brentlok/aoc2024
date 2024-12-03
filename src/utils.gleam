import file_streams/file_stream
import gleam/list

fn read_lines_loop(stream: file_stream.FileStream, callback: fn(String) -> value, acc: List(value)) -> List(value) {
    case file_stream.read_line(stream) {
        Ok(line) -> {
            read_lines_loop(stream, callback, [callback(line), ..acc])
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
