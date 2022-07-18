xquery version "3.1";
(:==========
Declare namespaces
==========:)
declare namespace m = "http://www.obdurodon.org/model";
declare namespace tei = "http://www.tei-c.org/ns/1.0";

(:==========
Declare variables to path
==========:)
declare variable $exist:root as xs:string := 
    request:get-parameter("exist:root", "xmldb:exist:///db/apps");
declare variable $exist:controller as xs:string := 
    request:get-parameter("exist:controller", "/05-base-models");
declare variable $path-to-data as xs:string := 
    $exist:root || $exist:controller || '/data';
(:==========
Declare variables
==========:)
declare variable $articles-coll := collection($path-to-data || '/hoax_xml');
declare variable $articles as element(tei:TEI)+ := $articles-coll/tei:TEI;

<m:titles>{
    for $article in $articles 
    return
        <m:title>{ 
            $article/descendant::tei:titleStmt/tei:title ! string()
        }</m:title>
}</m:titles>