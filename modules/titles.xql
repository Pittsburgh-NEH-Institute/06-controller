xquery version "3.1";
(:  
 : Enhancing the titles listing
 :  
 :)

(:
 : Declare namespaces
 :)
declare namespace m = "http://www.obdurodon.org/model";
declare namespace tei = "http://www.tei-c.org/ns/1.0";

(:
 : Declare variables for path-to-data
 :)
declare variable $exist:root as xs:string := 
    request:get-parameter("exist:root", "xmldb:exist:///db/apps");
declare variable $exist:controller as xs:string := 
    request:get-parameter("exist:controller", "/06-controller");
declare variable $path-to-data as xs:string := 
    $exist:root || $exist:controller || '/data';

(: 
 : Declare some more variables
 :)
declare variable $articles-coll := collection($path-to-data || '/hoax_xml');
declare variable $articles as element(tei:TEI)+ := $articles-coll/tei:TEI;
<m:titles>{
	for $article in $articles
	let $title as xs:string := $article/descendant::tei:titleStmt/tei:title ! string()
	order by $title
	return
	<m:title xml:id="{$article/@xml:id}">{$title}</m:title>
}</m:titles>
