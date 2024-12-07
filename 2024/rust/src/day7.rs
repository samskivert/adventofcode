fn parse(input: &str) -> Vec<(u64, Vec<u64>)> {
    let parse_eq = |line: &str| {
        let (answer, terms) = line.split_once(':').unwrap();
        (
            answer.parse().unwrap(),
            terms.trim().split_whitespace().map(|s| s.parse().unwrap()).collect(),
        )
    };
    input.lines().map(parse_eq).collect()
}

const OPS: [fn(u64, u64) -> u64; 3] =
    [|a, b| a + b, |a, b| a * b, |a, b| (a * (10_u64.pow(b.ilog10() + 1))) + b];

fn check(ops: &[fn(u64, u64) -> u64], y: u64, terms: &[u64], acc: u64, op: usize) -> bool {
    if terms.len() == 0 {
        acc == y
    } else {
        let nacc = ops[op](acc, terms[0]);
        (0..ops.len()).any(|op| check(ops, y, &terms[1..], nacc, op))
    }
}

fn calibrate(ops: &[fn(u64, u64) -> u64], input: &[(u64, Vec<u64>)]) -> u64 {
    input.iter().filter(|(y, terms)| check(ops, *y, terms, 0, 0)).map(|(y, _)| y).sum()
}

pub fn part1(input: &str) -> String {
    calibrate(&OPS[0..=1], &parse(input)).to_string()
}

pub fn part2(input: &str) -> String {
    calibrate(&OPS, &parse(input)).to_string()
}
