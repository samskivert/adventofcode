mod Day6 {

  def isStart (input :String, size :Int32, start :Int32) :Bool =
    input |> String.slice({ start = start }, { end = start+size }) |> String.toList |> List.toSet |> Set.size == size
  def startMarker (input :String, size :Int32) :Int32 =
    List.range(0, String.length(input)) |> List.find(isStart(input, size))
      |> Option.map(s -> s+size) |> Option.getWithDefault(0)

  pub def answer1 (input :List[String]) :Int32 = startMarker(head(input), 4)
  pub def answer2 (input :List[String]) :Int32 = startMarker(head(input), 14)
}