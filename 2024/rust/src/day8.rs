use itertools::Itertools;
use std::collections::HashSet;

fn solve(input: &str, resonate: bool) -> usize {
    let width = input.lines().next().unwrap().len() as isize;
    let height = input.lines().count() as isize;

    let mut signals = Vec::new();
    for (y, line) in input.lines().enumerate() {
        for (x, c) in line.chars().enumerate() {
            if c != '.' {
                signals.push((c, x as isize, y as isize));
            }
        }
    }
    let in_bounds = |x: isize, y: isize| x >= 0 && x < width && y >= 0 && y < height;

    let mut antinodes = HashSet::new();
    let propagate = |antinodes: &mut HashSet<(isize, isize)>, ax, ay, bx, by| {
        let dx = ax - bx;
        let dy = ay - by;
        let (mut abx, mut aby) = (ax + dx, ay + dy);
        while in_bounds(abx, aby) {
            antinodes.insert((abx, aby));
            if !resonate {
                break;
            }
            abx += dx;
            aby += dy;
        }
    };

    for freq in signals.iter().map(|&t| t.0) {
        for pair in signals.iter().filter(|&t| t.0 == freq).combinations(2) {
            let (&(_, ax, ay), &(_, bx, by)) = (pair[0], pair[1]);
            propagate(&mut antinodes, ax, ay, bx, by);
            propagate(&mut antinodes, bx, by, ax, ay);
            if resonate {
                antinodes.insert((ax, ay));
                antinodes.insert((bx, by));
            }
        }
    }
    antinodes.len()
}

pub fn part1(input: &str) -> String {
    solve(input, false).to_string()
}

pub fn part2(input: &str) -> String {
    solve(input, true).to_string()
}
