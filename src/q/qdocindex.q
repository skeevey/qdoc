dir:hsym `$.z.x 0;
files:key dir;
files:files where files like "*.html";
if[not count files; exit 0];
out:hsym `$.z.x 1;

getName:{[x]
  txt:read0 ` sv dir,`$x;
  txt 1+first where (txt~\:"<title>")
  };

body:raze (
  enlist "<table border=\"0\" width=\"100%\">";
  enlist "<td>";
  enlist "<td nowrap><font class=\"FrameItemFront\">";
  {"<a href=qdoc/",x," target=\"detailsFrame\">",(getName x),"</a><br>"} each string files;
  enlist "</font></td></tr><table>"
  )

html:raze(
  enlist "<html>";
  enlist "<head>";
  enlist "<title>";
  enlist "qdoc";
  enlist "</title>";
  enlist "<link rel=\"stylesheet\" type=\"text/css\" href=\"css/qdoc.css\">";
  enlist "</head>";
  enlist "<h2>qdoc</h2><p>";
  body 
  )

(` sv out,`index_frame.html)0:html;
exit 0;

