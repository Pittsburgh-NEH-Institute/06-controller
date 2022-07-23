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
        <style>
            body {{
                font-family: Verdana, Arial, Helvetica, sans-serif;
            }}
            input {{
                margin-right: 1em;
            }}
            p.error {{
                color: red;
                font-style: italic;
            }}
        </style>
    </head>
    <body>
        <h1>Article titles</h1>        
        <form action="titles" method="get">
            <input id="term" name="term" placeholder="[Search term]" value="{request:get-parameter('term','')}"/>
            <input id="submit" type="submit" value="Submit"/>
            <button id="clear-form" onclick="document.getElementById('term').value='';">Reset</button>
        </form>

        {if ($data//descendant::m:title)
        then
            <ul>{
                for $title in $data/descendant::m:title
                order by $title
                return <li>{$title ! string()}</li>
            }</ul>
        else
            <p>No matching articles found.</p>}
            
        {if ($data/descendant::m:error)
        then
            <p class="error">{$data/descendant::m:error}</p>
        else
            ()}
    </body>
</html>
