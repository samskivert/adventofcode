trait Day (val day :Int):
  def example1 = s"example$day.txt"
  def example2 = example1
  def input1 = s"input$day.txt"
  def input2 = input1
  def answer1 (input :Seq[String]) :Any
  def answer2 (input :Seq[String]) :Any

val days = Seq[Day](
  Day1, Day2, Day3, Day4, Day5, Day6, Day7, Day8, Day9, Day10, Day11, Day12, Day13, Day14, Day15,
  Day16, Day17, Day18, Day19, Day20, Day21, Day22, Day23, Day24, Day25)

@main def advent (day :Int = 1) :Unit =
  if (days.size >= day) then
    val dd = days(day-1)
    println(s"Day $day:")
    println(s"Example: ${dd.answer1(readFile(dd.example1))} / ${dd.answer2(readFile(dd.example2))}")
    println(s"My Input: ${dd.answer1(readFile(dd.input1))} / ${dd.answer2(readFile(dd.input2))}")
  else
    println(s"Day $day not yet implemented.")

// utilities
def readFile (name :String) :Seq[String] = classOf[Day].getResourceAsStream(name) match
  case null => throw new Exception(s"Missing file: $name")
  case rsrc => scala.io.Source.fromInputStream(rsrc).getLines.toSeq
