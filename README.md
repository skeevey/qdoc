# qdoc
HTML documentation generator for q files, based on javadoc.

## Usage
If you want a function to be picked up by qdoc, it must be preceded by `///`. This marks the start of the qdoc comment.

A description for your function follows on the next line, preceded by `//`. This can be a multi-line description, though each line must be preceded by `//`.

Following the description, you specify function parameters using `@param param_name param_description`. Again, these are preceded by `//`.
Finally, there is an optional `@return` tag, which indicates the return value of the function.

## Exmaple

```
///
// A description for your 
// function goes here.
//@param x what x does should go here
//@param y what y does goes here
//@return the sum of x and y
myfunc:{[x;y]
  x+y}
```

## Gemerating the documentation
src/sh/qdoc.sh is a shell script that generates the documetnation. It takes 3 paramters. The first is a directory in which to search for q files. The second is a directory in which to story the output HTML. (note that this directory will be cleared out when the shell script is run, so don't put anything important in there). THe third is an optional regex that's supplied to the `-name` param of `find`. The default is `"*.q"`.

e.g.

```
src/sh/qdoc.sh test/in test/out
```

  
