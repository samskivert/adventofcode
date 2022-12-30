object Day7 extends Day(7):

  class Directory:
    var files = Map[String, Int]()
    var dirs = Map[String, Directory]()
    def size :Int = files.values.sum + dirs.values.map(_.size).sum
    def foldDirs[Z] (z :Z)(op :(Z, Directory) => Z) :Z =
      dirs.values.foldLeft(op(z, this)) { (z, dir) => dir.foldDirs(z)(op) }
    def this (input :Seq[String]) =
      this()
      input.foldLeft((this, List[Directory]())) { (state, cmd) =>
        var (cwd, stack) = state
        if cmd startsWith "$ cd " then cmd.drop("$ cd ".size) match
          case ".." => (stack.head, stack.tail)
          case "/"  => (this, Nil)
          case name => (cwd.dirs(name), cwd :: stack)
        else
          if cmd == "$ ls" then {} // noop
          else if cmd startsWith "dir " then
            cwd.dirs += (cmd.drop("dir ".size) -> Directory())
          else
            val Array(size, name) = cmd.split(" ")
            cwd.files += (name -> size.toInt)
          state
      }

  override def answer1 (input :Seq[String]) =
    Directory(input).foldDirs(0) { (tot, dir) =>
      val size = dir.size
      if (size < 100000) then tot + size else tot
    }

  override def answer2 (input :Seq[String]) =
    val root = Directory(input)
    val minNeeded = 30000000 - (70000000 - root.size)
    root.foldDirs(30000000) { (smallest, dir) =>
      val size = dir.size
      if size >= minNeeded && size < smallest then size else smallest
    }
