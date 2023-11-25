mod Day1 {
  use Nel.Nel

  def readElves (lines :List[String]) :Nel[Int32] = parseInts(lines) |>
    Foldable.foldLeft((es, elem) -> match elem {
      case None => Nel.cons(0, es)
      case Some(n) => let Nel(h, t) = es ; Nel(h+n, t)
    }, Nel(0, Nil))

  pub def answer1 (input :List[String]) :Int32 = Nel.maximum(readElves(input))

  pub def answer2 (input :List[String]) :Int32 =
    readElves(input) |> Nel.sortBy(n -> -n) |> Nel.toList |> List.take(3) |> List.sum
}
