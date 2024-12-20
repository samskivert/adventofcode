fn parse(input: &str) -> (Vec<&str>, Vec<&str>) {
    let (towels, patterns) = input.split_once("\n\n").unwrap();
    (towels.split(", ").collect::<Vec<_>>(), patterns.split("\n").collect::<Vec<_>>())
}

fn count_ways(towels: &[&str], pattern: &str) -> usize {
    let mut ways = vec![0; pattern.len() + 1];
    ways[0] = 1;
    for i in 0..pattern.len() {
        for towel in towels.iter() {
            if pattern[i..].starts_with(towel) {
                ways[i + towel.len()] += ways[i];
            }
        }
    }
    ways[pattern.len()]
}

pub fn part1(input: &str) -> String {
    let (towels, patterns) = parse(input);
    patterns.iter().filter(|p| count_ways(&towels, p) > 0).count().to_string()
}

pub fn part2(input: &str) -> String {
    let (towels, patterns) = parse(input);
    patterns.iter().map(|p| count_ways(&towels, p)).sum::<usize>().to_string()
}
