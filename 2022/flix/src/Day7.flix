mod Day7 {

  enum Directory(String, Map[String, Int32], Map[String, Directory]) with ToString

  def size (d :Directory) :Int32 =
    let Directory.Directory(_, files, dirs) = d;
    let fileCount = files |> Map.valuesOf |> List.sum;
    let subdirFileCount = dirs |> Map.valuesOf |> List.map(size) |> List.sum;
    fileCount + subdirFileCount

  def emptyDir (name :String) :Directory = Directory.Directory(name, Map.empty(), Map.empty())
  def addDir (cname :String, child :Directory, parent :Directory) :Directory =
    let Directory.Directory(pname, cfiles, cdirs) = parent;
    Directory.Directory(pname, cfiles, cdirs |> Map.insert(cname, child))

  def parse (input :List[String], cwd :Directory, stack :List[Directory]) :Directory =
    let Directory.Directory(cname, cfiles, cdirs) = cwd;
    match input {
    case cmd :: t =>
      if (cmd == "$ ls" or cmd == "cd /") parse(t, cwd, stack) // ignore
      else if (String.startsWith({ prefix = "$ cd " }, cmd)) match String.sliceRight({ start = 5 }, cmd) {
        case ".." => parse(t, addDir(cname, cwd, head(stack)), tail(stack))
        case name => parse(t, Map.getWithDefault(name, cwd, cdirs), cwd :: stack)
      }
      else if (String.startsWith({ prefix = "dir " }, cmd))
        let name = String.sliceRight({ start = 4 }, cmd);
        parse(t, addDir(name, emptyDir(name), cwd), stack)
      else
        let (size, name) = splitPair(" ", cmd);
        parse(t, Directory.Directory(cname, Map.insert(name, parseInt(size), cfiles), cdirs), stack)

    case _ => match stack {
      case h :: t => parse(Nil, addDir(cname, cwd, h), t)
      case _ => cwd
    }
  }

  def foldDirs (a :a, op :(a, Directory) -> a, root :Directory) :a =
    let Directory.Directory(_, _, cdirs) = root;
    Map.valuesOf(cdirs) |> List.foldLeft((aa, dir) -> foldDirs(aa, op, dir), op(a, root))

  pub def answer1 (input :List[String]) :Int32 =
    parse(input, emptyDir(""), Nil) |> foldDirs(0, (tot, dir) ->
      let size = size(dir);
      if (size < 100000) tot + size else tot)

  pub def answer2 (input :List[String]) :Int32 =
    let root = parse(input, emptyDir(""), Nil);
    let minNeeded = 30000000 - (70000000 - size(root));
    root |> foldDirs(30000000, (smallest, dir) ->
      let size = size(dir);
      if (size >= minNeeded and size < smallest) size else smallest)
}