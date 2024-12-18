use std::cmp::Reverse;
use std::collections::BinaryHeap;

fn parse_coord(line: &str) -> (usize, usize) {
    let (x, y) = line.split_once(',').unwrap();
    (x.parse().unwrap(), y.parse().unwrap())
}

fn dijkstras(grid: &Vec<Vec<bool>>, start: (usize, usize), end: (usize, usize)) -> usize {
    let mut dist = vec![vec![usize::MAX; grid[0].len()]; grid.len()];
    dist[start.1][start.0] = 0;
    let mut pq = BinaryHeap::new();
    pq.push(Reverse((0, start)));
    while let Some(Reverse((len, current))) = pq.pop() {
        if current == end {
            return len;
        }
        for (dx, dy) in [(0, 1), (1, 0), (0, -1), (-1, 0)] {
            let (nx, ny) = (current.0 as isize + dx, current.1 as isize + dy);
            if nx < 0 || nx >= grid[0].len() as isize || ny < 0 || ny >= grid.len() as isize {
                continue;
            }
            let (nx, ny) = (nx as usize, ny as usize);
            if grid[ny][nx] {
                continue;
            }
            let new_len = len + 1;
            if new_len < dist[ny][nx] {
                dist[ny][nx] = new_len;
                pq.push(Reverse((new_len, (nx, ny))));
            }
        }
    }
    usize::MAX
}

pub fn part1(input: &str) -> String {
    let coords: Vec<_> = input.lines().map(parse_coord).collect();
    let (size, steps) = if coords.len() == 25 { (7, 12) } else { (71, 1024) };
    let mut grid = vec![vec![false; size]; size];
    for &coord in coords.iter().take(steps) {
        grid[coord.1][coord.0] = true;
    }
    dijkstras(&grid, (0, 0), (size - 1, size - 1)).to_string()
}

pub fn part2(input: &str) -> String {
    let coords: Vec<_> = input.lines().map(parse_coord).collect();
    let size = if coords.len() == 25 { 7 } else { 71 };
    let mut grid = vec![vec![false; size]; size];
    for (cx, cy) in coords {
        grid[cy][cx] = true;
        if dijkstras(&grid, (0, 0), (size - 1, size - 1)) == usize::MAX {
            return format!("{},{}", cx, cy);
        }
    }
    "none".to_string()
}
