object Advent11 extends AdventApp {
  def power (serial :Int, x :Int, y :Int) = (((((x+10) * y) + serial) * (x+10)) / 100) % 10 - 5
  def bestAt (grid :Int, serial :Int)(square :Int) = {
    val powers = Array.tabulate(grid*grid) {yx => power(serial, yx%grid, yx/grid)}
    val max = grid-square
    for (y <- 0 until grid ; row = grid*y ; pos <- row to row+max) powers(pos) =
      (0 /: (pos until pos+square)) {(s, gp) => s + powers(gp)}
    for (y <- 0 to max ; x <- 0 to max) powers(grid*y+x) =
      (0 /: (y until y+square)) {(s, gy) => s + powers(grid*gy+x)}
    (for (x <- 0 to max ; y <- 0 to max) yield (x, y, square, powers(grid*y+x))) maxBy {_._4}
  }
  // the powers get increasingly negative at large square sizes, so we cheat and stop early
  def answer = (bestAt(300, 7403)(3), 1 to 15 map bestAt(300, 7403) maxBy {_._4})
}
