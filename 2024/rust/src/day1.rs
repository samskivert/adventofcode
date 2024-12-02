fn parse(input: String) -> (Vec<u32>, Vec<u32>) {
    let pairs = input.lines().map(|line| {
        let (a, b) = line.split_once(' ').unwrap();
        (a.parse().unwrap(), b.trim().parse().unwrap())
    });
    let lefts: Vec<u32> = pairs.clone().map(|(a, _)| a).collect();
    let rights: Vec<u32> = pairs.map(|(_, b)| b).collect();
    (lefts, rights)
}

pub fn part1(input: String) -> String {
    let (mut left, mut right) = parse(input);
    left.sort();
    right.sort();
    left.iter()
        .zip(right.iter())
        .map(|(a, b)| u32::abs_diff(*a, *b))
        .sum::<u32>()
        .to_string()
}

pub fn part2(input: String) -> String {
    let (left, right) = parse(input);
    left.iter()
        .map(|a| *a * right.iter().copied().filter(|b| *b == *a).count() as u32)
        .sum::<u32>()
        .to_string()
}
