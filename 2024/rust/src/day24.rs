use std::collections::HashMap;

static GLYPHS: &str = "abcdefghijklmnopqrstuvwxyz0123456789";

fn to_code(s: &str) -> u16 {
    s.chars().fold(0, |acc, c| acc * 36 + GLYPHS.find(c).unwrap() as u16)
}
// fn from_code(c: u16) -> String {
//     let mut s = String::new();
//     let mut c = c;
//     for _ in 0..3 {
//         s.push(GLYPHS.chars().nth(c as usize % 36).unwrap());
//         c /= 36;
//     }
//     s.chars().rev().collect()
// }

#[derive(Debug, Clone)]
enum Op {
    And,
    Or,
    Xor,
}

#[derive(Debug, Clone)]
struct Gate {
    a: u16,
    b: u16,
    op: Op,
    out: u16,
}

fn parse(input: &str) -> (HashMap<u16, u8>, Vec<Gate>) {
    let (inits, gates) = input.split_once("\n\n").unwrap();
    let inits = inits
        .lines()
        .map(|line| line.split_once(':').unwrap())
        .map(|(k, v)| (to_code(k), v.trim().parse().unwrap()))
        .collect();
    let gates = gates
        .lines()
        .map(|line| {
            let mut parts = line.split(' ');
            let a = to_code(parts.next().unwrap());
            let opstr = parts.next().unwrap();
            let b = to_code(parts.next().unwrap());
            parts.next(); // skip ->
            let out = to_code(parts.next().unwrap());
            let op = match opstr {
                "AND" => Op::And,
                "OR" => Op::Or,
                "XOR" => Op::Xor,
                _ => panic!("Unknown op: {}", opstr),
            };
            Gate { a, b, op, out }
        })
        .collect();
    (inits, gates)
}

fn read_reg(state: &HashMap<u16, u8>, reg: &str) -> usize {
    let mut out: usize = 0;
    let mut bit = 0;
    while let Some(v) = state.get(&to_code(&format!("{}{:02}", reg, bit))) {
        out += (*v as usize) << bit;
        bit += 1;
    }
    out
}

fn eval(state: &HashMap<u16, u8>, gates: &[Gate]) -> usize {
    let mut gates = gates.to_vec();
    let mut state = state.clone();
    while !gates.is_empty() {
        let plen = gates.len();
        gates.retain(|gate| {
            if let Some(a) = state.get(&gate.a) {
                if let Some(b) = state.get(&gate.b) {
                    let out = match gate.op {
                        Op::And => a & b,
                        Op::Or => a | b,
                        Op::Xor => a ^ b,
                    };
                    state.insert(gate.out, out);
                    false
                } else {
                    true
                }
            } else {
                true
            }
        });
        if gates.len() == plen {
            return 0;
        }
    }
    read_reg(&state, "z")
}

pub fn part1(input: &str) -> String {
    let (state, gates) = parse(input);
    eval(&state, &gates).to_string()
}

fn swap(gates: &mut Vec<Gate>, a: &str, b: &str) {
    let ac = to_code(a);
    let bc = to_code(b);
    let aidx = gates.iter().position(|g| g.out == ac).unwrap();
    let bidx = gates.iter().position(|g| g.out == bc).unwrap();
    let tmp = gates[aidx].out;
    gates[aidx].out = gates[bidx].out;
    gates[bidx].out = tmp;
}

fn check(state: &HashMap<u16, u8>, gates: &[Gate]) -> bool {
    let x = read_reg(&state, "x");
    let y = read_reg(&state, "y");
    let xy = x + y;
    let z = eval(&state, &gates);

    if xy == z {
        true
    } else {
        for bit in 0..47 {
            let mask = (1 << (bit + 1)) - 1;
            if z & mask != xy & mask {
                println!("differs at bit {}", bit);
                break;
            }
        }
        false
    }
}

// fn print_dot(gates: &[Gate]) {
//     println!("digraph G {{");
//     for gate in gates {
//         let (shape, sym) = match gate.op {
//             Op::And => ("triangle", "&"),
//             Op::Or => ("invtriangle", "|"),
//             Op::Xor => ("invhouse", "^"),
//         };
//         let gate_id = format!("{}", from_code(gate.out));
//         println!("  {} [label=\"{} {}\", shape={}]", gate_id, gate_id, sym, shape);
//         println!("  {} -> {}", from_code(gate.a), gate_id);
//         println!("  {} -> {}", from_code(gate.b), gate_id);
//     }
//     println!("}}");
// }

pub fn part2(input: &str) -> String {
    let (state, mut gates) = parse(input);
    swap(&mut gates, "z15", "qnw");
    swap(&mut gates, "z20", "cqr");
    swap(&mut gates, "nfj", "ncd");
    swap(&mut gates, "z37", "vkg");
    check(&state, &gates);
    let mut swaps = ["z15", "qnw", "z20", "cqr", "nfj", "ncd", "z37", "vkg"];
    swaps.sort();
    swaps.join(",")
}
