use bigdecimal::{BigDecimal, ToPrimitive};
use regex::{Captures, Regex};
use std::str::FromStr;

fn parse(input: &str) -> Vec<[BigDecimal; 6]> {
    const RE: &str = r"\S+ A: X\+(\d+), Y\+(\d+)\n\S+ B: X\+(\d+), Y\+(\d+)\n\S+: X=(\d+), Y=(\d+)";
    let extract = |c: Captures<'_>| c.extract().1.map(|s| BigDecimal::from_str(s).unwrap());
    Regex::new(RE).unwrap().captures_iter(input).map(extract).collect()
}

fn solve(machs: Vec<[BigDecimal; 6]>, off: BigDecimal) -> BigDecimal {
    let is_int = |x: &BigDecimal| (x - x.round(0)).abs().to_f64().unwrap() < f64::EPSILON;
    let mut presses = BigDecimal::from(0);
    for [ax, ay, bx, by, px, py] in machs {
        let (opx, opy) = (&px + &off, &py + &off);
        let m = (&opy - (&ay / &ax) * &opx) / (&by - &bx * &ay / &ax);
        let n = (&opx - &bx * &m) / &ax;
        if is_int(&m) && is_int(&n) {
            presses += &n.round(0) * 3 + &m.round(0);
        }
    }
    presses
}

pub fn part1(input: &str) -> String {
    solve(parse(input), BigDecimal::from(0)).to_string()
}

pub fn part2(input: &str) -> String {
    solve(parse(input), BigDecimal::from(10000000000000_u64)).to_string()
}
