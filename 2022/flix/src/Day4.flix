mod Day4 {

  def parsePair (pair :String) :(Int32, Int32) =
    let (p1, p2) = pair |> splitPair("-") ; (parseInt(p1), parseInt(p2))
  def parse (line :String) :((Int32, Int32), (Int32, Int32)) =
    let (r1, r2) = line |> splitPair(",") ; (parsePair(r1), parsePair(r2))

  def subsumes (r1 :(Int32, Int32), r2: (Int32, Int32)) :Bool =
    (fst(r1) <= fst(r2) and snd(r1) >= snd(r2)) or (fst(r2) <= fst(r1) and snd(r2) >= snd(r1))

  def contains (r :(Int32, Int32), n :Int32) :Bool = fst(r) <= n and snd(r) >= n
  def overlaps (r1 :(Int32, Int32), r2: (Int32, Int32)) :Bool =
    contains(r1, fst(r2)) or contains(r1, snd(r2)) or contains(r2, fst(r1)) or contains(r2, snd(r1))

  pub def answer1 (input :List[String]) :Int32 =
    input |> List.map(parse) |> List.filter(pp -> subsumes(fst(pp), snd(pp))) |> List.length

  pub def answer2 (input :List[String]) :Int32 =
    input |> List.map(parse) |> List.filter(pp -> overlaps(fst(pp), snd(pp))) |> List.length
}