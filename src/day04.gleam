import gleam/option
import gleam/string
import gleam/io
import gleam/list
import utils

const search_word = ["X", "M", "A", "S"]
const directions = [
    #(-1, 0),
    #(1, 0),
    #(0, -1),
    #(0, 1),
    #(-1, -1),
    #(1, -1),
    #(-1, 1),
    #(1, 1),
]

pub fn a() {
    let grid = utils.read_lines("inputs/4.txt", fn (line) {
        string.split(line, "")
    }) |> list.reverse

    let x_indexes = grid
        |>list.index_map(fn (row, row_index) {
            row
                |> list.index_map(fn(item, index) { #(index, item) })
                |> list.filter(fn (item) {
                    case item {
                        #(_, item) if item == "X" -> True
                        _ -> False
                    }
                })
                |> list.map(fn (item) {
                    let #(index, _) = item

                    #(row_index, index)
                })
        })
        |> list.flatten

    let result = x_indexes
        |> list.fold(0, fn (acc, curr) {
            let count = directions
                |> list.filter(fn (direction) {
                    let #(row_index_update, col_index_update) = direction

                    is_correct_loop(grid, curr, row_index_update, col_index_update, "X")
                })
                |> list.length

            acc + count
        })

    io.debug(result)
}

fn is_correct_loop(grid: List(List(String)), current: #(Int, Int), update_row: Int, update_col: Int, current_letter: String) -> Bool {
    let #(row_index, col_index) = current

    let next_row_index = row_index + update_row
    let next_col_index = col_index + update_col

    let next_letter = utils.get_index(search_word, utils.find_index(search_word, current_letter) + 1)
    let new_indexes = #(next_row_index, next_col_index)

    case is_correct(grid, new_indexes, next_letter) {
        True -> {
            case next_letter {
                "S" -> True
                _ -> is_correct_loop(grid, new_indexes, update_row, update_col, next_letter)
            }
        }
        False -> False
    }
}

fn is_correct(grid: List(List(String)), next: #(Int, Int), letter: String) -> Bool {
    let #(row_index, index) = next

    case utils.get_index_safe(grid, row_index) {
        option.Some(row) -> {
            case utils.get_index_safe(row, index) {
                option.Some(item) -> item == letter
                option.None -> False
            }
        }
        option.None -> False
    }
}

pub fn b() {
    let grid = utils.read_lines("inputs/4.txt", fn (line) {
        string.split(line, "")
    }) |> list.reverse

    let a_indexes = grid
        |>list.index_map(fn (row, row_index) {
            row
                |> list.index_map(fn(item, index) { #(index, item) })
                |> list.filter(fn (item) {
                    case item {
                        #(_, item) if item == "A" -> True
                        _ -> False
                    }
                })
                |> list.map(fn (item) {
                    let #(index, _) = item

                    #(row_index, index)
                })
        })
        |> list.flatten

    let result = a_indexes
        |> list.fold(0, fn (acc, curr) {
            let #(row_index, col_index) = curr

            let a = get_letter(grid, row_index - 1, col_index - 1) == "M" && get_letter(grid, row_index + 1, col_index + 1) == "S"
            let b = get_letter(grid, row_index + 1, col_index + 1) == "M" && get_letter(grid, row_index - 1, col_index - 1) == "S"
            let c = get_letter(grid, row_index + 1, col_index - 1) == "M" && get_letter(grid, row_index - 1, col_index + 1) == "S"
            let d = get_letter(grid, row_index - 1, col_index + 1) == "M" && get_letter(grid, row_index + 1, col_index - 1) == "S"

            let count = [a,b,c,d]
                |> list.filter(fn (item) { item })
                |> list.length

            case count {
                2 -> {
                    acc + 1
                }
                _ -> {
                    acc
                }
            }
        })

    io.debug(result)
}

fn get_letter(grid: List(List(String)), row_index: Int, col_index: Int) -> String {
    case utils.get_index_safe(grid, row_index) {
        option.Some(row) -> {
            case utils.get_index_safe(row, col_index) {
                option.Some(item) -> item
                option.None -> ""
            }
        }
        option.None -> ""
    }
}