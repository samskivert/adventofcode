use std::collections::HashMap;
use std::collections::HashSet;

fn to_code(s: &str) -> u16 {
    s.chars().fold(0, |acc, c| acc * 26 + (c as u16 - 'a' as u16))
}
fn from_code(c: u16) -> String {
    format!("{}{}", (c / 26 + 'a' as u16) as u8 as char, (c % 26 + 'a' as u16) as u8 as char)
}
fn is_t(c: u16) -> bool {
    c / 26 == 't' as u16 - 'a' as u16
}

fn parse(input: &str) -> HashMap<u16, HashSet<u16>> {
    fn parse_link(line: &str) -> (u16, u16) {
        let (a, b) = line.split_once('-').unwrap();
        (to_code(a), to_code(b))
    }
    let mut conns = HashMap::new();
    for (a, b) in input.lines().map(parse_link) {
        conns.entry(a).or_insert(HashSet::new()).insert(b);
        conns.entry(b).or_insert(HashSet::new()).insert(a);
    }
    conns
}

fn ns<'a>(conns: &'a HashMap<u16, HashSet<u16>>, comp: &'a u16) -> &'a HashSet<u16> {
    conns.get(comp).unwrap()
}
fn linked(conns: &HashMap<u16, HashSet<u16>>, a: &u16, b: &u16) -> bool {
    a == b || ns(conns, a).contains(b)
}

pub fn part1(input: &str) -> String {
    let conns = parse(input);
    let mut count = 0;
    for (comp0, links0) in conns.iter() {
        for comp1 in links0.iter().filter(|&c| c > comp0) {
            for comp2 in ns(&conns, comp1).iter().filter(|&c| c > comp1) {
                if linked(&conns, comp2, comp0) && (is_t(*comp2) || is_t(*comp1) || is_t(*comp0)) {
                    count += 1;
                }
            }
        }
    }
    count.to_string()
}

pub fn part2(input: &str) -> String {
    let conns = parse(input);
    let mut longest = HashSet::new();
    for (comp, links) in conns.iter() {
        let mut nodes = HashSet::from([*comp]);
        for n in links.iter() {
            for nn in ns(&conns, n).iter().filter(|&nn| nn != comp && links.contains(nn)) {
                nodes.insert(*nn);
            }
        }
        if !nodes.iter().all(|n| nodes.iter().all(|nn| linked(&conns, nn, n))) {
            continue;
        }
        if nodes.len() > longest.len() {
            longest = nodes;
        }
    }
    let mut codes = longest.iter().map(|c| from_code(*c)).collect::<Vec<_>>();
    codes.sort();
    codes.join(",")
}
