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
    request:get-parameter("exist:controller", "/06-controller");
declare variable $path-to-data as xs:string := 
    $exist:root || $exist:controller || '/data';

(:==========
Search term is saved to $term
If the user supplies no value $request:get-parameter() thinks it's an empty
    string, and not missing (that is, not an empty sequence). The second
    statement checks for this situation with:
    
    if ($retrieved-term) ...
    
    This keeps the specified term if it is anything other than an empty string,
    and turns it into an empty sequence if it is an empty string. Having an empty
    sequence instead of an empty string becomes useful later.
==========:)
declare variable $retrieved-term as xs:string? := (request:get-parameter('term', ()));
declare variable $term as xs:string? := if ($retrieved-term) then $retrieved-term else ();

(:==========
Declare variables

This demonstration project contains three declarations for $articles. Only one is allowed,
so comment out the other two.
==========:)
declare variable $articles-coll := collection($path-to-data || '/hoax_xml');
(: 
    The first version, with no predicate, finds all articles
:)
(: declare variable $articles as element(tei:TEI)+ := $articles-coll/tei:TEI; :)
(: 
    The second version keeps articles with text that contains $term (case-sensitive). 
    We change the repetition indicator on $articles because there could be no matches.
:)
(: declare variable $articles as element(tei:TEI)* := $articles-coll/tei:TEI[contains(., $term)]; :)
(: 
    The third version keeps articles with text that contains $term (case-insensitive).
    If there is no specified term, matches() needs an empty string, as its second argument! 
:)
declare variable $regex-term as xs:string := if ($term) then $term else '';
declare variable $articles as element(tei:TEI)* := $articles-coll/tei:TEI[matches(., $regex-term, 'i')];

<m:titles>{
    for $article in $articles 
    return
        <m:title>{ 
            $article/descendant::tei:titleStmt/tei:title ! string()
        }</m:title>
}</m:titles>