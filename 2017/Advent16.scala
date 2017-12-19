object Advent16 extends AdventApp {
  val dancers = "abcdefghijklmnop"
  val scratch = Array.fill(dancers.length)(' ')

  def spin (c :Int)(ds :Array[Char]) = {
    System.arraycopy(ds, ds.length-c, scratch, 0, c)
    System.arraycopy(ds, 0, ds, c, ds.length-c)
    System.arraycopy(scratch, 0, ds, 0, c)
  }
  def exch (a :Int, b :Int)(ds :Array[Char]) = { val tmp = ds(a) ; ds(a) = ds(b) ; ds(b) = tmp }
  def part (a :Char, b :Char)(ds :Array[Char]) = exch(ds indexOf a, ds indexOf b)(ds)
  def step (cmd :String) = cmd charAt 0 match {
    case 's' => spin(cmd substring 1 toInt)
    case 'p' => part(cmd charAt 1, cmd charAt 3)
    case 'x' => val Array(a, b) = cmd substring 1 split "/" ; exch(a.toInt, b.toInt)
  }

  val input = readline("data/input16.txt").split(",")
  val prog = input map(step)
  def dance (count :Int) = {
    val ds = dancers.toArray
    var ii = 0 ; do {
      prog foreach (p => p(ds))
      ii += 1
      // if we detect a loop at N we can skip ahead to count - count%N
      if (ds.mkString == dancers) ii = count - (count % ii)
    } while (ii < count)
    ds.mkString
  }

  def answer = (dance(1), dance(1000*1000*1000))
}
