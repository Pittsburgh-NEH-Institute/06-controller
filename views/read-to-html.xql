(:==========
The model is in the model namespace, so we declare it here.
==========:)
declare namespace m="http://www.obdurodon.org/model";
declare namespace t="http://www.tei-c.org/ns/1.0";
(:==========
These declarations create valid HTML 5 output that is returned
to the user with headers saying that it should conform to XML
well-formedness requirements.
==========:)
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "html";
declare option output:media-type "text/html";
declare option output:omit-xml-declaration "yes";
declare option output:html-version "5.0";
declare option output:indent "no";
declare option output:include-content-type "no";
(:==========
Receive the output of the XQuery that created the model
and assign it to the variable $data
==========:)
declare variable $data as document-node() := request:get-data();
declare function t:make-ceteicean($node as node()) as node() {
    typeswitch($node)
        case document-node() return 
            document {
                for $child in $node/node()
                    return t:make-ceteicean($child)
            }
        case element() return
            switch(namespace-uri($node))
                case "http://www.tei-c.org/ns/1.0" return 
                  element {concat("tei-", lower-case(local-name($node)))} {
                      attribute data-origname {local-name($node)},
                      if ($node/@xml:id) then
                          attribute xml:id {$node/@xml:id}
                      else (),
                      if (not($node/node())) then
                          attribute data-empty {"true"}
                      else (),
                      for $attr in $node/@*
                      return t:make-ceteicean($attr),
                      for $child in $node/node()
                      return t:make-ceteicean($child) }
                default return
                  element {concat("m-", lower-case(local-name($node)))} {
                      attribute data-origname {lower-case(local-name($node))},
                      for $attr in $node/@*
                      return t:make-ceteicean($attr),
                      for $child in $node/node()
                      return t:make-ceteicean($child)
                  }
        case attribute() return
            switch(namespace-uri($node))
                case "http://www.w3.org/XML/1998/namespace" return
                    attribute {local-name($node)} {$node}
                default return 
                    attribute {local-name($node)} {replace($node, '&amp;amp;', "&amp;#36;")}
        default return $node
};
<html>
  <head>
    <script type="text/javascript" src="assets/js/CETEI.js"></script>
    <style>
      body {{
        font-family: Verdana, Arial, Helvetica, sans-serif;
        margin: 2em;
      }}
      tei-tei {{
        display: block;
        margin: auto;
        width: 65%;
      }}
      tei-p {{
        display: block;
      }}
      tei-teiheader > * {{
        display: none;
      }}
      tei-teiheader tei-filedesc {{
        display: block;
        margin-bottom: 1em;
      }}
      tei-filedesc > * {{
        display: none;
      }}
      tei-filedesc > tei-titlestmt {{
        display: block;
        font-weight: bold;
        font-size: 200%;
      }}
      tei-titlestmt > tei-respstmt {{
        display: block;
        font-size: 60%;
      }}
      m-aux {{
        display: block;
        margin: 2em auto;
        width: 65%;
      }}
      m-aux * {{
        display: block;
      }}
      m-publisher {{
        font-weight: bold;
      }}
    </style>
  </head>
  <body>
    { t:make-ceteicean($data/*) }
    <script>
      let c = new CETEI();
      c.removeBehavior("tei","teiHeader"); // The TEI Header is hidden by default, but we want to display some of it.
      c.processPage(); // Runs CETEIcean on the current page.
    </script>
  </body>
</html>
