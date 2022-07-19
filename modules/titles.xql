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
declare variable $aux-coll := collection($path-to-data || '/aux_xml');
declare variable $persons as element(tei:listPerson)+ := $aux-coll/tei:TEI//tei:listPerson;
<m:titles>{
		for $article in $articles 
		return
		<m:titleStmt>{
			(<m:title>{ 
				$article/descendant::tei:titleStmt/tei:title ! string()
			}</m:title>,
		for $resp-name in $article/descendant::tei:titleStmt/tei:respStmt/tei:name 
		return <m:resp>
				<m:resp-name>{ 
				$resp-name ! string()
				}</m:resp-name>
				<m:resp-resp>{ 
				$resp-name/preceding-sibling::tei:resp ! string()
				}</m:resp-resp>
			</m:resp>)
	}</m:titleStmt>
}</m:titles>
