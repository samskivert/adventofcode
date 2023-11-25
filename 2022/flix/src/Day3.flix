mod Day3 {

  def split (sack :String) :(Set[Char], Set[Char]) =
    let half = String.length(sack)/2;
    (sack |> String.take(half) |> String.toList |> List.toSet,
     sack |> String.drop(half) |> String.toList |> List.toSet)
  def mispacked (left :Set[Char], right :Set[Char]) :Char =
    Set.intersection(left, right) |> Set.toList |> head
  def priority (c :Char) :Int32 = Char.toBmpCodePoint(c) - (if (c >= 'a') 96 else 38)
  def badge (sacks :List[Set[Char]]) :Char = match sacks {
    case s :: ss => ss |> List.foldLeft(Set.intersection, s) |> Set.toList |> head
    case _ => bug!("Yay for strict functional programming!")
  }

  def grouped (size :Int32, list :List[a]) :List[List[a]] =
    List.range(0, List.length(list) / size) |>
      List.map(ii -> list |> List.drop(ii*size) |> List.take(size))

  pub def answer1 (input :List[String]) :Int32 =
    input |> List.map(split) |> List.map(lr -> mispacked(fst(lr), snd(lr)))
          |> List.map(priority) |> List.sum

  pub def answer2 (input :List[String]) :Int32 =
    input |> List.map(s -> s |> String.toList |> List.toSet) |> grouped(3)
          |> List.map(badge) |> List.map(priority) |> List.sum
}