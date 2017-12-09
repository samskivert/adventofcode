object Advent09 extends AdventApp {
  def parserec (in :java.io.Reader) = {
    def loop (nest :Int, skip :Boolean, garbage :Boolean, score :Int, gcount :Int) :(Int, Int) = {
      val c = in.read
      if (c < 0 || c == '\n') (score, gcount)
      else if (skip) loop(nest, false, garbage, score, gcount)
      else if (garbage) {
        if (c == '!') loop(nest, true, garbage, score, gcount)
        else if (c == '>') loop(nest, false, false, score, gcount)
        else loop(nest, false, true, score, gcount+1)
      }
      else if (c == '{') loop(nest+1, false, false, score, gcount)
      else if (c == '}') loop(nest-1, false, false, score+nest-1, gcount)
      else if (c == '<') loop(nest, false, true, score, gcount)
      else if (c == ',') loop(nest, false, false, score, gcount)
      else throw new AssertionError("Expected group or garbage, got: " + c.toChar)
    }
    loop(1, false, false, 0, 0)
  }
  def parse (in :java.io.Reader) = {
    var nest = 1 ; var skip = false ; var garbage = false ; var score = 0 ; var gcount = 0
    var c = in.read
    while (c >= 0 && c != '\n') {
      if (skip) skip = false
      else if (garbage) {
        if (c == '!') skip = true
        else if (c == '>') garbage = false
        else gcount += 1
      }
      else if (c == '{') nest += 1
      else if (c == '}') { nest -= 1 ; score += nest }
      else if (c == '<') garbage = true
      else if (c != ',') throw new AssertionError("Expected group or garbage, got: " + c.toChar)
      c = in.read
    }
    (score, gcount)
  }
  def answer = parse(new java.io.FileReader("data/input09.txt"))
}
