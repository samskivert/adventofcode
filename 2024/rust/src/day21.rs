use std::collections::HashMap;

type Pos = (i64, i64);

fn numpad() -> HashMap<char, Pos> {
    HashMap::from([
        ('7', (0, 0)),
        ('8', (1, 0)),
        ('9', (2, 0)),
        ('4', (0, 1)),
        ('5', (1, 1)),
        ('6', (2, 1)),
        ('1', (0, 2)),
        ('2', (1, 2)),
        ('3', (2, 2)),
        ('0', (1, 3)),
        ('A', (2, 3)),
    ])
}
static NBLANK: Pos = (0, 3);

static DBLANK: Pos = (0, 0);
static UP: Pos = (1, 0);
static DGO: Pos = (2, 0);
static LEFT: Pos = (0, 1);
static DOWN: Pos = (1, 1);
static RIGHT: Pos = (2, 1);

fn count_presses(
    cache: &mut HashMap<(Pos, Pos, i64), i64>,
    a: Pos,
    b: Pos,
    blank: Pos,
    depth: i64,
) -> i64 {
    let can_cache = blank == DBLANK;
    if can_cache {
        if let Some(&len) = cache.get(&(a, b, depth)) {
            return len;
        }
    }
    let hdist = (a.0 - b.0).abs();
    let hdir = if a.0 < b.0 { RIGHT } else { LEFT };
    let vdist = (a.1 - b.1).abs();
    let vdir = if a.1 < b.1 { DOWN } else { UP };
    let mut presses = 0;
    if depth == 0 {
        presses += hdist + vdist + 1;
    } else if vdist == 0 {
        presses += count_presses(cache, DGO, hdir, DBLANK, depth - 1) + hdist - 1;
        presses += count_presses(cache, hdir, DGO, DBLANK, depth - 1);
    } else if hdist == 0 {
        presses += count_presses(cache, DGO, vdir, DBLANK, depth - 1) + vdist - 1;
        presses += count_presses(cache, vdir, DGO, DBLANK, depth - 1);
    } else {
        let vhlen = (count_presses(cache, DGO, vdir, DBLANK, depth - 1) + vdist - 1)
            + (count_presses(cache, vdir, hdir, DBLANK, depth - 1) + hdist - 1)
            + count_presses(cache, hdir, DGO, DBLANK, depth - 1);
        let hvlen = (count_presses(cache, DGO, hdir, DBLANK, depth - 1) + hdist - 1)
            + (count_presses(cache, hdir, vdir, DBLANK, depth - 1) + vdist - 1)
            + count_presses(cache, vdir, DGO, DBLANK, depth - 1);
        if (b.0, a.1) == blank {
            presses += vhlen;
        } else if (a.0, b.1) == blank {
            presses += hvlen;
        } else {
            presses += std::cmp::min(vhlen, hvlen);
        }
    }
    if can_cache {
        cache.insert((a, b, depth), presses);
    }
    presses
}

fn solve(code: &str, depth: i64) -> i64 {
    let npad = numpad();
    let ncode = format!("A{}", code).chars().map(|c| npad[&c]).collect::<Vec<_>>();
    let mut cache = HashMap::new();
    let presses: i64 =
        ncode.windows(2).map(|w| count_presses(&mut cache, w[0], w[1], NBLANK, depth)).sum();
    code[0..code.len() - 1].parse::<i64>().unwrap() * presses
}

pub fn part1(input: &str) -> String {
    input.lines().map(|code| solve(code, 2)).sum::<i64>().to_string()
}

pub fn part2(input: &str) -> String {
    input.lines().map(|code| solve(code, 25)).sum::<i64>().to_string()
}
