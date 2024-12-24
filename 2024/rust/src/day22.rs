fn next(seed: u64) -> u64 {
    let seed = (seed ^ (seed * 64)) % 16777216;
    let seed = (seed ^ (seed / 32)) % 16777216;
    let seed = (seed ^ (seed * 2048)) % 16777216;
    seed
}

struct Seq {
    deltas: [i8; 4],
    price: u16,
}

fn seqs_n(seed: u64, n: u64) -> Vec<Seq> {
    let mut seed = seed;
    let mut seqs = Vec::new();
    let mut deltas = [0, 0, 0, 0];
    for ii in 0..n - 1 {
        let price = (seed % 10) as i8;
        seed = next(seed);
        let nprice = (seed % 10) as i8;
        let delta = nprice - price;
        deltas[0] = deltas[1];
        deltas[1] = deltas[2];
        deltas[2] = deltas[3];
        deltas[3] = delta;
        if ii > 2 {
            seqs.push(Seq { price: nprice as u16, deltas });
        }
    }
    seqs
}

pub fn part1(input: &str) -> String {
    let seeds = input.lines().map(|line| line.parse::<u64>().unwrap());
    seeds.map(|s| (0..2000).fold(s, |s, _| next(s))).sum::<u64>().to_string()
}

fn find_best(seqss: &[Vec<Seq>], seq: &Seq, total: u16) -> u16 {
    if seqss.len() == 0 {
        total
    } else if let Some(nseq) = seqss[0].iter().find(|nseq| seq.deltas == nseq.deltas) {
        find_best(&seqss[1..], seq, total + nseq.price)
    } else {
        find_best(&seqss[1..], seq, total)
    }
}

pub fn part2(input: &str) -> String {
    let seeds = input.lines().map(|line| line.parse::<u64>().unwrap());
    let seqss = seeds.map(|s| seqs_n(s, 2000)).collect::<Vec<_>>();
    seqss[0].iter().map(|seq| find_best(&seqss[1..], seq, seq.price)).max().unwrap().to_string()
}
