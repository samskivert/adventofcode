object Advent17 extends AdventApp {
  def spin1 (size :Int, step :Int) = {
    val buffer = Array.fill(size)(0)
    val fpos = (1 until size).foldLeft(0)((pos, value) => {
      val npos = (pos + step) % value + 1
      if (npos < value) System.arraycopy(buffer, npos, buffer, npos+1, value-npos)
      buffer(npos) = value
      npos
    })
    buffer(fpos+1)
  }
  def spin2 (size :Int, step :Int) = {
    var pos = 0 ; var latest1 = 0
    var value = 1 ; while (value <= size) {
      pos = (pos + step) % value + 1
      if (pos == 1) latest1 = value
      value += 1
    }
    latest1
  }
  def answer = (spin1(2018, 312), spin2(50*1000*1000, 312))
}
