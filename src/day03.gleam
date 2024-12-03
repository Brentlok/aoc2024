import gleam/int
import gleam/result
import gleam/string
import gleam/io
import gleam/regex
import gleam/list
import utils

pub fn a() {
    let assert Ok(mul_regex) = regex.from_string("mul\\(\\d{1,3},\\d{1,3}\\)")

    let result = utils.read_lines("inputs/3.txt", fn (line) {
        regex.scan(mul_regex, line)
            |> list.map(fn (match) {
                match.content
                    |> string.replace("mul(", "")
                    |> string.replace(")", "")
                    |> string.split(",")
                    |> list.map(fn (number) {
                        int.parse(number) |> result.unwrap(0)
                    })
            })
            |> list.fold(0, fn (acc, curr) {
                let assert [a, b] = curr

                acc + int.multiply(a, b)
            })
    })
        |> list.fold(0, fn (acc, curr) {
            acc + curr
        })

    io.debug(result)
}

pub fn b() {
    let assert Ok(mul_regex) = regex.from_string("mul\\(\\d{1,3},\\d{1,3}\\)|do\\(\\)|don't\\(\\)")

    let joined_line = utils.read_lines("inputs/3.txt", fn (line) {
        line
    }) |> list.fold("", fn (acc, curr) {
        string.append(curr, acc)
    })

    let result = regex.scan(mul_regex, joined_line)
            |> list.map(fn (match) {
                match.content
            })
            |> loop_matches(True, 0)

    io.debug(result)
}

fn loop_matches(matches: List(String), enabled: Bool, acc: Int) -> Int {
    case matches {
        [match, ..rest] -> {
            case match {
                "do()" -> loop_matches(rest, True, acc)
                "don't()" -> loop_matches(rest, False, acc)
                _ if enabled -> {
                    let assert [a, b] = match
                        |> string.replace("mul(", "")
                        |> string.replace(")", "")
                        |> string.split(",")
                        |> list.map(fn (number) {
                            int.parse(number) |> result.unwrap(0)
                        })
                    
                    loop_matches(rest, enabled, acc + int.multiply(a, b))
                }
                _ -> loop_matches(rest, enabled, acc)
            }
        }
        _ -> acc
    }
}