import gleam/io
import gleam/string
import gleam/result
import gleam/list
import gleam/int
import gleam/bool
import utils

pub fn a() {
    io.debug("Part 1 day two")
}

pub fn b() {
    let result = utils.read_lines("inputs/2.txt", fn (line) {
    line
        |> string.replace("\n", "")
        |> string.split(" ")
        |> list.map(fn (id) {
            result.unwrap(int.parse(id), 0)
        })
    })
        |> list.filter(fn (row) {
            is_safe(row, -1, -1, Undefined, False, row, 0)
        })
        |> list.length

    io.debug(result)
}

type Direction {
    Undefined
    Ascending
    Descending
}

fn is_safe(row: List(Int), current: Int, next: Int, direction: Direction, level_removed: Bool, original_row: List(Int), index: Int) -> Bool {
    let #(row, current, next, direction) = get_data(row, current, next, direction)
    let next_safe = is_next_safe(current, next, direction)

    case next_safe {
        True -> {
            case row {
                [new_next, ..rest] -> is_safe(rest, next, new_next, direction, level_removed, original_row, index + 1)
                _ -> True
            }
        }
        False -> {
            case level_removed {
                True -> False
                False -> {
                    is_safe(utils.remove_index(original_row, index), -1, -1, Undefined, True, original_row, 0)
                    || is_safe(utils.remove_index(original_row, index + 1), -1, -1, Undefined, True, original_row, 0)
                    || is_safe(utils.remove_index(original_row, index - 1), -1, -1, Undefined, True, original_row, 0)
                }
            }
        }
    }
}

fn is_next_safe(current: Int, next: Int, direction: Direction) -> Bool {
    let diff = next - current
    let is_ascending = case direction {
        Ascending -> True
        _ -> False
    }

    case is_ascending {
        // Ascending ^
        True if diff > 0 && diff <= 3 -> True
        // Descending v
        False if diff < 0 && diff >= -3 -> True
        _ -> False
    }
}

fn get_data(row: List(Int), current_raw: Int, next_raw: Int, direction: Direction) -> #(List(Int), Int, Int, Direction) {
    let current = bool.guard(current_raw == -1, result.unwrap(list.first(row), 0), fn () { current_raw })
    let next = bool.guard(next_raw == -1, result.unwrap(list.first(list.drop(row, 1)), 0), fn () { next_raw })
    let row = bool.guard(current_raw == -1, list.drop(row, 2), fn() { row })
    let current_direction = case next > current {
        True -> Ascending
        False -> Descending
    }
    let direction = bool.guard(direction == Undefined, current_direction, fn () { direction })

    #(row, current, next, direction)
}
