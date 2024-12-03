fn parse(input: &String) -> Vec<Vec<u32>> {
    input
        .lines()
        .map(|line| line.split(' ').map(|a| a.parse().unwrap()).collect())
        .collect()
}

fn pairs<'a>(report: &'a Vec<u32>) -> impl Iterator<Item = (u32, u32)> + 'a {
    report.windows(2).map(|w| (w[0], w[1]))
}

fn safe(report: &Vec<u32>) -> bool {
    fn safe_diff(d: u32) -> bool {
        d >= 1 && d <= 3
    }
    (pairs(report).all(|(a, b)| a < b) || pairs(report).all(|(a, b)| a > b))
        && pairs(report).all(|(a, b)| safe_diff(u32::abs_diff(a, b)))
}

pub fn part1(input: &String) -> String {
    parse(input).iter().filter(|&r| safe(r)).count().to_string()
}

pub fn safe_damped(report: &Vec<u32>) -> bool {
    for dampidx in 0..report.len() {
        let damped: Vec<u32> = report
            .iter()
            .enumerate()
            .filter(|(ii, _)| *ii != dampidx)
            .map(|(_, &vv)| vv)
            .collect();
        if safe(&damped) {
            return true;
        }
    }
    false
}

pub fn part2(input: &String) -> String {
    parse(input)
        .iter()
        .filter(|&r| safe_damped(r))
        .count()
        .to_string()
}
