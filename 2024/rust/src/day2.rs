fn parse(input: &str) -> Vec<Vec<u32>> {
    input.lines().map(|line| line.split(' ').map(|a| a.parse().unwrap()).collect()).collect()
}

fn pairs(report: &[u32]) -> impl Iterator<Item = (u32, u32)> + '_ {
    report.windows(2).map(|w| (w[0], w[1]))
}

fn safe(report: &[u32]) -> bool {
    let safe_diff = |d: u32| d >= 1 && d <= 3;
    (pairs(report).all(|(a, b)| a < b) || pairs(report).all(|(a, b)| a > b))
        && pairs(report).all(|(a, b)| safe_diff(u32::abs_diff(a, b)))
}

pub fn part1(input: &str) -> String {
    parse(input).iter().filter(|&r| safe(r)).count().to_string()
}

pub fn safe_damped(report: &[u32]) -> bool {
    (0..report.len()).any(|dd| {
        let damped: Vec<u32> =
            report.iter().enumerate().filter(|(ii, _)| *ii != dd).map(|(_, &vv)| vv).collect();
        safe(&damped)
    })
}

pub fn part2(input: &str) -> String {
    parse(input).iter().filter(|&r| safe_damped(r)).count().to_string()
}
