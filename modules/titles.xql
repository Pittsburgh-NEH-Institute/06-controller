xquery version "3.1";
(: ----------
 : Create model for titles list with search interface
 ---------- :)

(: ----------
 : Declare namespaces
 ----------- :)
declare namespace m = "http://www.obdurodon.org/model";
declare namespace tei = "http://www.tei-c.org/ns/1.0";

(: ----------
 : Declare variables for path-to-data
 ----------:)
declare variable $exist:root as xs:string := 
    request:get-parameter("exist:root", "xmldb:exist:///db/apps");
declare variable $exist:controller as xs:string := 
    request:get-parameter("exist:controller", "/06-controller");
declare variable $path-to-data as xs:string := 
    $exist:root || $exist:controller || '/data';

(: ----------
Supplied search term is saved to $term, defaults to empty string
---------- :)
declare variable $term as xs:string? := (request:get-parameter('term', ''));
declare variable $articles-coll := collection($path-to-data || '/hoax_xml');
(: ----------
This demonstration project contains way of filtering $articles. Only one is 
allowed, so copy the active one into the try block and comment out the other 
two.

The first version, with no predicate, finds all articles?

    for $article in $articles-coll/tei:TEI

The second version keeps articles with text that contains $term 
(case-sensitive). We change the repetition indicator on $articles because there 
could be no matches:

    for $article in $articles-coll/tei:TEI[contains(., $term)]

The third version keeps articles with text that contains $term 
(case-insensitive). If there is no specified term, matches() needs an empty 
string, as its second argument, and we made that the default when we declared
$term.

    for $article in $articles-coll/tei:TEI[matches(., $term, 'i')]
---------- :)
try {
    <m:titles>{
        for $article in $articles-coll/tei:TEI[matches(., $term, 'i')] 
        return
            <m:title>{ 
                $article/descendant::tei:titleStmt/tei:title ! string()
            }</m:title>
    }</m:titles>
} catch * {
    (: Lucene patterns cannot begin with ? or *. This traps any 
    Lucene-invalid input :)
    <m:error>{$err:description}</m:error>
}
