(:==========
The model is in the model namespace, so we declare it here.
==========:)
declare namespace m="http://www.obdurodon.org/model";
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
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <title>Article titles</title>
        <link rel="stylesheet" type="text/css" href="resources/css/style.css"/>
    </head>
    <body>
        <h1>Article titles</h1>
        <ul>{
            for $titleStmt in $data/m:titles/m:titleStmt
            for $element in $titleStmt/child::element()
            return typeswitch($element)
                case element(m:title) return <li><a href="">{$element/text()}</a></li>
                case element(m:resp) return <span><i>{$element/m:resp-resp/text() || " " || $element/m:resp-name/text() }</i><br/></span>
                default return ()
        }</ul>
    </body>
</html>
