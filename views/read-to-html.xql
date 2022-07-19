(:==========
The model is in the model namespace, so we declare it here.
==========:)
declare namespace m="http://www.obdurodon.org/model";
declare namespace tei="http://www.tei-c.org/ns/1.0";
(:==========
These declarations create valid HTML 5 output that is returned
to the user with headers saying that it should conform to XML
well-formedness requirements.
==========:)
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "xhtml";
declare option output:media-type "application/xhtml+xml";
declare option output:omit-xml-declaration "no";
declare option output:html-version "5.0";
declare option output:indent "no";
declare option output:include-content-type "no";
(:==========
Receive the output of the XQuery that created the model
and assign it to the variable $data
==========:)
declare variable $data as document-node() := request:get-data();

declare function local:dispatch($node as node()*) as item()* {
    typeswitch($node) 
        case text() return $node
        case element(tei:TEI) return 
            <html xmlns="http://www.w3.org/1999/xhtml">
                <head>
                    <title>{$node//tei:titleStmt/tei:title/text()}</title>
                </head>
                <body>
                    <h2>{$node//tei:titleStmt/tei:title/text()}</h2>
                    <div class="byline">
                        <address class="author">{local:passthru($node//tei:respStmt[1])}</address>
                    </div>
                    {local:passthru($node//tei:body)}
                </body>
            </html>
        case element(tei:p) return 
            <p xmlns="http://www.w3.org/1999/xhtml">
                {local:passthru($node)}
            </p>
        case element(tei:q) return '"' || local:passthru($node) || '"'
        case element(tei:rs) return <i xmlns="http://www.w3.org/1999/xhtml">{local:passthru($node)}</i>
        default return local:passthru($node)
};

declare function local:passthru($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
};

local:dispatch($data)


