fn parse(input: &str) -> (Vec<(u32, u32)>, Vec<Vec<u32>>) {
    let (rules, updates) = input.split_once("\n\n").unwrap();
    let pairs = rules.lines().map(|line| line.split_once("|").unwrap());
    (
        pairs.map(|(a, b)| (a.parse().unwrap(), b.parse().unwrap())).collect(),
        updates.lines().map(|line| line.split(",").map(|n| n.parse().unwrap()).collect()).collect(),
    )
}

fn is_valid(rules: &Vec<(u32, u32)>, update: &Vec<u32>) -> bool {
    let mut pairs = update.windows(2).map(|w| (w[0], w[1]));
    pairs.all(|(a, b)| rules.iter().any(|&(r1, r2)| (a, b) == (r1, r2)))
}

pub fn part1(input: &str) -> String {
    let (rules, updates) = parse(input);
    updates
        .iter()
        .filter(|&update| is_valid(&rules, update))
        .map(|update| update[update.len() / 2])
        .sum::<u32>()
        .to_string()
}

pub fn part2(input: &str) -> String {
    let (rules, updates) = parse(input);
    let middle = |n: u32, update: &Vec<u32>| {
        rules.iter().filter(|(a, b)| n == *a && update.contains(b)).count() == update.len() / 2
    };
    let score = |update: &Vec<u32>| {
        if is_valid(&rules, &update) {
            0
        } else {
            *update.iter().find(|&n| middle(*n, update)).unwrap()
        }
    };
    updates.iter().map(score).sum::<u32>().to_string()
}
