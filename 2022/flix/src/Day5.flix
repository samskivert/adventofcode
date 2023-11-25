mod Day5 {

  def pluck (cycle :Int32, n :Int32, list :List[a]) :List[a] = list |> List.zipWithIndex
    |> List.filterMap(ee -> if (Int32.mod(fst(ee), cycle) == n) Some(snd(ee)) else None)

  def execute (applyMove :(Map[Char, List[Char]], Int32, Char, Char) -> Map[Char, List[Char]], input :List[String]) :String =
    let (stacksDiagram, moves) = splitOnBlanks2(input);
    let initStacks = stacksDiagram |> List.map(String.toList) |> List.transpose |> pluck(4, 1);
    let emptyStacks = initStacks |> List.map(ss -> List.reverse(ss) |> head) |> List.toMapWith(_ -> Nil);
    let stacks = initStacks |> List.foldLeft((stacks, initStack) -> match List.reverse(initStack) {
      case id :: crates => crates |> List.foldLeft((ss, c) -> if (c != ' ') Map.adjust(cs -> c :: cs, id, ss) else ss, stacks)
      case _ => bug!("Invalid crate spec ${initStack}")
    }, emptyStacks);
    moves |> List.foldLeft((ss, move) ->
      let (cc, src, dst) = move |> String.splitOn({ substr = " "}) |> pluck(2, 1) |> listTo3;
      applyMove(ss, parseInt("${cc}"), String.charAt(0, src), String.charAt(0, dst)),
      stacks) |> Map.joinWith((_, v) -> "${head(v)}", "")

  def move1 (stacks :Map[Char, List[Char]], count :Int32, src :Char, dst :Char) :Map[Char, List[Char]] =
    List.range(0, count) |> List.foldLeft((stks, _) -> match stks |> Map.getWithDefault(src, Nil) {
      case h :: t => stks |> Map.adjust(ss -> h :: ss, dst) |> Map.adjust(_ -> t, src)
      case _ => bug!("Empty stack ${src} (d=${dst})")
    }, stacks)

  pub def answer1 (input :List[String]) :String = input |> execute(move1)

  def move2 (stacks :Map[Char, List[Char]], count :Int32, src :Char, dst :Char) :Map[Char, List[Char]] =
    let sstack = Map.getWithDefault(src, Nil, stacks);
    stacks |> Map.adjust(ds -> ds |> List.append(List.take(count, sstack)), dst)
           |> Map.adjust(ss -> ss |> List.drop(count), src)

  pub def answer2 (input :List[String]) :String = input |> execute(move2)
}