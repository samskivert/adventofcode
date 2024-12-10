fn id(pos: usize) -> i16 {
    match pos % 2 {
        0 => (pos / 2) as i16,
        _ => -1,
    }
}

fn to_blocks(id: i16, len: u32) -> impl Iterator<Item = i16> {
    std::iter::repeat(id).take(len as usize)
}

fn checksum(blocks: impl Iterator<Item = i16>) -> u64 {
    blocks
        .enumerate()
        .filter(|(_, id)| *id != -1)
        .map(|(pos, id)| (id as usize * pos) as u64)
        .sum::<u64>()
}

pub fn part1(input: &str) -> String {
    let mut blocks = input
        .chars()
        .map(|c| c.to_digit(10).unwrap())
        .enumerate()
        .flat_map(|(pos, len)| to_blocks(id(pos), len))
        .collect::<Vec<i16>>();

    // defragment block by block
    let mut end = blocks.len() - 1;
    let mut pos = 0;
    while pos < end {
        if blocks[end] == -1 {
            end -= 1;
        } else if blocks[pos] != -1 {
            pos += 1;
        } else {
            blocks[pos] = blocks[end];
            blocks[end] = -1;
            end -= 1;
        }
    }

    checksum(blocks.iter().cloned()).to_string()
}

pub fn part2(input: &str) -> String {
    let mut files = input
        .chars()
        .map(|c| c.to_digit(10).unwrap())
        .enumerate()
        .map(|(pos, len)| (id(pos), len))
        .collect::<Vec<(i16, u32)>>();

    // defragment file by file
    let mut end = files.len() - 1;
    while end > 0 {
        let (id, len) = files[end];
        if id != -1 {
            let pos = files.iter().position(|&(bid, blen)| bid == -1 && blen >= len).unwrap_or(end);
            if pos < end {
                let olen = files[pos].1;
                files[pos].0 = id;
                files[pos].1 = len;
                files[end].0 = -1;
                if olen > len {
                    files.insert(pos + 1, (-1, olen - len));
                }
                if end > 0 && files[end - 1].0 == -1 {
                    files[end - 1].1 += files[end].1;
                    files.remove(end);
                    end -= 1;
                }
                if end < files.len() - 1 && files[end + 1].0 == -1 {
                    files[end].1 += files[end + 1].1;
                    files.remove(end + 1);
                }
            }
        }
        end -= 1;
    }

    checksum(files.iter().flat_map(|&(id, len)| to_blocks(id, len))).to_string()
}
