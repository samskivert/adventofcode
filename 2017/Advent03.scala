object Advent03 extends AdventApp {
  def coord (target :Int) :(Int, Int) = {
    var x = 0 ; var y = 0 ; var n = 1 ; var dx = 1 ; var dy = 1 ; var dn = 1
    while (n < target) {
      // move in x
      x += dx*dn
      n += dn
      if (n >= target) return (x-(n-target)*dx, y)
      // move in y
      y += dy*dn
      n += dn
      if (n >= target) return (x, y-(n-target)*dy)
      // increment dn
      dn += 1
      // flip deltas
      dx *= -1
      dy *= -1
    }
    (x, y)
  }

  def coordrec (target :Int) :(Int, Int) = {
    def loopx (x :Int, y :Int, dx :Int, n :Int, seg :Int, turn :Int) :(Int, Int) =
      if (n == target) (x, y)
      else if (n < turn) loopx(x+dx, y, dx, n+1, seg, turn)
      else loopy(x, y, dx, n, seg, n+seg)
    def loopy (x :Int, y :Int, dy :Int, n :Int, seg :Int, turn :Int) :(Int, Int) =
      if (n == target) (x, y)
      else if (n < turn) loopy(x, y+dy, dy, n+1, seg, turn)
      else loopx(x, y, -dy, n, seg+1, n+seg+1)
    loopx(0, 0, 1, 1, 1, 2)
  }

  def mandist (coord :(Int, Int)) = math.abs(coord._1) + math.abs(coord._2)

  val grid = Array.fill(256*256)(0) // hack, could use a map but whatevs
  def pos (x :Int, y :Int) = (y+128)*256 + (x+128)
  def sum (x :Int, y :Int) = if (x == 0 && y == 0) 1 else
  grid(pos(x-1, y+1)) + grid(pos(x, y+1)) + grid(pos(x+1, y+1)) +
    grid(pos(x-1, y  )) +                     grid(pos(x+1, y  )) +
    grid(pos(x-1, y-1)) + grid(pos(x, y-1)) + grid(pos(x+1, y-1))

  def find (target :Int) :Int = {
    var x = 0 ; var y = 0 ; var n = 1 ; var dx = 1 ; var dy = 1 ; var dn = 1
    while (true) {
      // move in x
      val tnx = n + dn
      while (n < tnx) {
        val xval = sum(x, y)
        grid(pos(x, y)) = xval
        if (xval > target) return xval
        x += dx
        n += 1
      }
      // move in y
      val tny = n + dn
      while (n < tny) {
        val yval = sum(x, y)
        grid(pos(x, y)) = yval
        if (yval > target) return yval
        y += dy
        n += 1
      }
      // increment dn
      dn += 1
      // flip deltas
      dx *= -1
      dy *= -1
    }
    0 // unreached
  }

  def findrec (target :Int) :Int = {
    def loopx (x :Int, y :Int, dx :Int, n :Int, seg :Int, turn :Int) :Int = {
      val v = sum(x, y)
      grid(pos(x, y)) = v
      if (v >= target) v
      else if (n < turn) loopx(x+dx, y, dx, n+1, seg, turn)
      else loopy(x, y, dx, n, seg, n+seg)
    }
    def loopy (x :Int, y :Int, dy :Int, n :Int, seg :Int, turn :Int) :Int = {
      val v = sum(x, y)
      grid(pos(x, y)) = v
      if (n >= target) v
      else if (n < turn) loopy(x, y+dy, dy, n+1, seg, turn)
      else loopx(x, y, -dy, n, seg+1, n+seg+1)
    }
    loopx(0, 0, 1, 1, 1, 2)
  }

  def answer = (mandist(coordrec(265149)), findrec(265149))
}
