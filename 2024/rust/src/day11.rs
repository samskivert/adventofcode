use std::collections::HashMap;

fn evolve(memo: &mut HashMap<(u64, i32), u64>, n: u64, b: i32) -> u64 {
    if b == 0 {
        1
    } else if let Some(v) = memo.get(&(n, b)) {
        *v
    } else {
        let v = if n == 0 {
            evolve(memo, 1, b - 1)
        } else {
            let digits = n.ilog10() + 1;
            if digits % 2 == 0 {
                let divis = 10_u64.pow(digits / 2);
                evolve(memo, n / divis, b - 1) + evolve(memo, n % divis, b - 1)
            } else {
                evolve(memo, n * 2024, b - 1)
            }
        };
        memo.insert((n, b), v);
        v
    }
}

fn parse_and_evolve(input: &str, b: i32) -> u64 {
    let stones = input.split_whitespace().map(|s| s.parse::<u64>().unwrap()).collect::<Vec<_>>();
    let mut memo = HashMap::new();
    stones.iter().map(|s| evolve(&mut memo, *s, b)).sum::<u64>()
}

pub fn part1(input: &str) -> String {
    parse_and_evolve(input, 25).to_string()
}

pub fn part2(input: &str) -> String {
    parse_and_evolve(input, 75).to_string()
}
