//=====================
// Parsers
//=====================
.qdoc.res:([]func:(); descr:(); param:(); paramDesc:(); return:())

.qdoc.empty:{all null x};
.qdoc.rem:{x where not .qdoc.empty each x};
k).qdoc.ltrim:{$[~t&77h>t:@x;.z.s[;y]'x;y=*x;(+/&\y=x)_x;x]}
k).qdoc.rtrim:{$[~t&775>t:@x;.z.s[;y]'x;y=last x;|.qdoc.ltrim[;y]@|x;x]}
.qdoc.trim:{.qdoc.ltrim[;y] .qdoc.rtrim[;y] x}
.qdoc.trsp:{{ssr[x;"  ";" "]}/[x]};

.qdoc.TAGS:`param`return`returns;
.qdoc.isValidTag:{[x] $[not "@"~first x;0b;(`$1_x)in .qdoc.TAGS]};
.qdoc.isTagLine:{("//"~2#x) and "@"~first .qdoc.ltrim/[x;" /"]};

.qdoc.parse.str:{[x]
  str:.qdoc.trsp .qdoc.ltrim/[x;" /"];
  tag:first split:" "vs str;
  if[not .qdoc.isValidTag tag; :()];
  tag:`$1_tag;
  .qdoc.parse[tag] 1_split
  };

.qdoc.parse.param:{[x]
  param:x 0;
  descr:ltrim " "sv 1_x;
  `param`paramDesc!(param;descr)
  };

.qdoc.parse.returns:.qdoc.parse.return:{[x] enlist[`return]!enlist " " sv x}

.qdoc.parse.func:{[f]
  tagLineNum:where .qdoc.isTagLine each f;
  if[not count tagLineNum; :()]; 
  preamble:trim "<br>" sv .qdoc.rem {.qdoc.ltrim/[x;" /"]} each f til first tagLineNum;
  tagLines:f tagLineNum;
  metad:distinct (uj/)enlist each {x where count each x} .qdoc.parse.str each tagLines;
  funcName:first ":"vs f 1+max tagLineNum;
  upsert[`.qdoc.res; (`func`descr!(funcName;preamble)),/:metad];
  };

.qdoc.funcTxt:{[x]
  p:"[",(";"sv .qdoc.rem x`param),"]";
  "<b>",x[`func],"</b>:{",p,"}"
  };

.qdoc.fn:{[x]
  ext:last split:"."vs last "/"vs string x;
  `$("_"sv -1_split),".",ext,".html"
  };

//======================
// HTML
//======================
.qdoc.html.head:{[x]
  (
  "<html>";
  "<head>";
  "<title>";
  x;
  "</title>";
  "<line rel=\"stylesheet\" type=\"text/css\" href=\"qdoc.css\">";
  "</head>";
  "<h2>",x,"</h2><p>"
  )
  };

.qdoc.html.end:enlist "</html>"

.qdoc.html.section:{[name;txt]
  (
  "<a name=\"",name,"\">";
  "<table border=\"1\" width=\"100%\" cellpadding=\"3\" cellspacing=\"0\">";
  "<tr bgcolor=\"#CCCCFF\" class=\"TableHeadingColor\">";
  "<th align=\"left\" colspan\"1\">";
  "<font size=\"+2\">";
  "<b>",txt,"</b>";
  "</tr>";
  "</table>"
  )
  };

.qdoc.html.function:{[x]
  paramtxt:{"<dd><b><code>",x,"</code></b> ",y}'[x`param; x`paramDesc];
  (
  enlist "<a name=\"",x[`func],"\">";
  enlist "<h3>",x[`func],"</h3>";
  enlist "<pre>";
  enlist .qdoc.funcTxt x;
  enlist "</pre>";
  enlist "<dl>";
  enlist "<dd>",x[`descr];
  enlist "<p>";
  enlist "<dd><dl>";
  enlist "<dt><b>Parameters:</b><dd>";
  paramtxt;
  enlist "<dt><b>Returns:</b><dd>";
  .qdoc.rem x`return;
  enlist "</dl>";
  enlist "</dd>"; 
  enlist "</dl>";
  enlist "<hr>"
  )
  };

.qdoc.html.summary:{[]
  txt:
  ("<a name=\"function_summary\">";
  "<table border=\"\" width=\"100%\" cellpadding=\"3\" cellspacing=\"0\">";
  "<tr bgcolor=\"#CCCCFF\" clas=\"TableHeadingColor\">";
  "<th align=\"left\" colspan=\"2\">";
  "<font size=\"+2\">";
  "<b>Function Summary</b>";
  "</font>"
  "</tr>"
  );
  body:raze {
    (
    "<tr bgcolor=\"white\" class=\"TableRowColor\">";
    "<td align=\"right\" valing=\"top\" width=\"1%\"><code><a href=#",x[`func],">",x[`func],"</code></td>";
    "<td>",x[`descr],"</td>";
    "</td>"
    )
  } each .qdoc.res;
  txt,body,enlist "</table><p>"
  };

//================================
// HTML File generation
//================================
outDir:hsym `$.z.x 1;
txt:read0 `$.z.x 0;
f:`$last "/"vs .z.x 0;
-1 "[qdoc] [documenting ",string[f],"]";
funcs:(0,where "///"~/:txt) cut txt;

.qdoc.parse.func each funcs;

if[not count .qdoc.res; exit 0];

.qdoc.res:0!`func`descr xgroup .qdoc.res;

//==================================
head:.qdoc.html.head string f;
funcSection:.qdoc.html.section["functions";"Functions"];
func:raze raze each .qdoc.html.function each .qdoc.res;
summary:.qdoc.html.summary[];
body:head,summary,funcSection,func,.qdoc.html.end;
(` sv outDir,.qdoc.fn f)0:body;
exit 0;


  
