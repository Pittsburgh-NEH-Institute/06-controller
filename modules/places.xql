xquery version "3.1";
(:===
Declare namespaces
==:)
declare namespace hoax = "http://obdurodon.org/hoax";
declare namespace m = "http://www.obdurodon.org/model";
declare namespace tei = "http://www.tei-c.org/ns/1.0";

(:===
Declare global variables to path
===:)
declare variable $exist:root as xs:string := 
    request:get-parameter("exist:root", "xmldb:exist:///db/apps");
declare variable $exist:controller as xs:string := 
    request:get-parameter("exist:controller", "/05-base-models");
declare variable $path-to-data as xs:string := 
    $exist:root || $exist:controller || '/data';
(:===
Declare variables
===:)
declare variable $place-coll := doc($path-to-data || '/aux_xml/places.xml');
declare variable $places as element(tei:place)+ := $place-coll//tei:place;

<m:places>{
for $place in $places
    let $name as xs:string* := $place/tei:placeName => string-join(',')
    let $geo as element(tei:geo)? := $place/tei:location/tei:geo
    let $lat as xs:double := substring-before($geo, " ") ! number()
    let $long as xs:double := substring-after($geo, " ") ! number()
    where $geo (: Filter out those without geocoordinates:)
    return
        <m:place>
            <m:name>{$name}</m:name>
            <m:geo>
                <m:lat>{$lat}</m:lat>
                <m:long>{$long}</m:long>                    
            </m:geo>
        </m:place>
}</m:places>