xquery version "3.1";

(:~
 : 
 : @author timathom
 :)

module namespace lookups = "https://bibfra.mx/2019/lookups";

declare namespace atom = "http://www.w3.org/2005/Atom";
declare namespace bf = "http://id.loc.gov/ontologies/bibframe/";
declare namespace dcterms = "http://purl.org/dc/terms/";
declare namespace opensearch = "http://a9.com/-/spec/opensearch/1.1/";
declare namespace owl = "http://www.w3.org/2002/07/owl#";
declare namespace rdf = "http://www.w3.org/1999/02/22-rdf-syntax-ns#";
declare namespace rdfs = "http://www.w3.org/2000/01/rdf-schema#";
declare namespace skos = "http://www.w3.org/2004/02/skos/core#";

declare
%rest:path("/test")
%rest:GET
%output:method("xml")
function lookups:test(

) as item()* {

  let $f := function() { prof:sleep(2000) }
  return (
    $f(), <response>Done!</response>
  )

};

declare
%rest:path("/dashboard-test")
%rest:GET
%rest:query-param("netID", "{$netID}")
%output:method("xml")
function lookups:sparql-request-test(
  $netID
) as item()* {
  let $start := prof:current-ms()
  let $user := ""
  let $pass := ""
  let $targ := ""
  let $type := "application/sparql-query"
  let $head := "application/xml"

  let $extent-check := (
    http:send-request(
      <http:request
          method="post"
          href="{$targ}"
          username="{$user}"
          password="{$pass}"
          send-authorization="true">
          <http:header
              name="Content-Type"
              value="{$type}; charset=utf-8"/>
          <http:header
              name="Accept"
              value="{$head}"/>
          <http:body
              media-type="{$type}">{
                  ``[
            PREFIX bf: <http://id.loc.gov/ontologies/bibframe/>
                        
            ASK { 
              GRAPH <http://library.yale.edu/ld4p> {     
                ?manifest a bf:Instance .                 
              }
            }
          ]``
        }</http:body>
      </http:request>
    )[2]
  )
  return
    <response time="{prof:current-ms() - $start}"/>


};

declare
%rest:path("/dashboard")
%rest:GET
%rest:query-param("netID", "{$netID}")
%output:method("xml")
function lookups:sparql-request(
  $netID
) as item()* {
  let $start := prof:current-ms()
  let $user := "admin"
  let $pass := "metaphactorY"
  let $targ := "http://10.5.38.65:10214/sparql"
  let $type := "application/sparql-query"
  let $head := "application/xml"
  
  
  
  let $extent-check := (
    http:send-request(
      <http:request
          method="post"
          href="{$targ}"
          username="{$user}"
          password="{$pass}"
          send-authorization="true">
          <http:header
              name="Content-Type"
              value="{$type}; charset=utf-8"/>
          <http:header
              name="Accept"
              value="{$head}"/>
          <http:body
              media-type="{$type}">{
                  ``[
            PREFIX bf: <http://id.loc.gov/ontologies/bibframe/>
            PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
            PREFIX bflc: <http://id.loc.gov/ontologies/bflc/>
            PREFIX svde: <http://share-vde.org/rdfBibframe/>
            PREFIX yul1: <http://library.yale.edu/ld4p/>
            
            SELECT ?manifest ?main
            WHERE { 
              GRAPH <http://library.yale.edu/ld4p> {     
                ?manifest a bf:Instance ; 
                          bf:extent ?extent ;
                          bf:title ?title ;
                          bf:adminMetadata ?admin .
                ?admin bflc:catalogerId ?cat .                
                ?title bf:mainTitle ?main .
                FILTER((STR(?cat)) = "`{$netID}`")
                FILTER(NOT EXISTS { ?extent rdf:value ?value } || NOT EXISTS {?extent rdfs:label ?label})
                
              }
            }
          ]``
        }</http:body>
      </http:request>
    )[2]
  )
  let $supplied-check := (
    http:send-request(
      <http:request
          method="post"
          href="{$targ}"
          username="{$user}"
          password="{$pass}"
          send-authorization="true">
          <http:header
              name="Content-Type"
              value="{$type}; charset=utf-8"/>
          <http:header
              name="Accept"
              value="{$head}"/>
          <http:body
              media-type="{$type}">{
                  ``[
            PREFIX bf: <http://id.loc.gov/ontologies/bibframe/>
            PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
            PREFIX bflc: <http://id.loc.gov/ontologies/bflc/>
            PREFIX svde: <http://share-vde.org/rdfBibframe/>
            PREFIX yul1: <http://library.yale.edu/ld4p/>
            SELECT ?resource ?main
            WHERE { 
              GRAPH <http://library.yale.edu/ld4p> {             
                ?resource a bf:Instance ; 
                          bf:title ?title ;
                          bf:adminMetadata ?admin .
                ?admin bflc:catalogerId ?cat .
                ?title bf:mainTitle ?main .
                FILTER((STR(?cat)) = "`{$netID}`")
                FILTER(NOT EXISTS {?resource <https://library.yale.edu/ld4p/terms/264_statements> ?statements})
              }      
            } 
          ]``
        }</http:body>
      </http:request>
    )[2]
   
  )
  let $provision-check-statements := (
     http:send-request(
      <http:request
          method="post"
          href="{$targ}"
          username="{$user}"
          password="{$pass}"
          send-authorization="true">
          <http:header
              name="Content-Type"
              value="{$type}; charset=utf-8"/>
          <http:header
              name="Accept"
              value="{$head}"/>
          <http:body
              media-type="{$type}">{
                  ``[
            PREFIX bf: <http://id.loc.gov/ontologies/bibframe/>
            PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
            PREFIX bflc: <http://id.loc.gov/ontologies/bflc/>
            PREFIX svde: <http://share-vde.org/rdfBibframe/>
            PREFIX yul1: <http://library.yale.edu/ld4p/>
            SELECT ?resource ?main
            WHERE { 
              GRAPH <http://library.yale.edu/ld4p> {             
                ?resource a bf:Instance ; 
                          bf:title ?title ;
                          bf:adminMetadata ?admin .
                ?admin bflc:catalogerId ?cat .
                ?title bf:mainTitle ?main .                
                FILTER((STR(?cat)) = "`{$netID}`")
                FILTER(
                  NOT EXISTS {?resource bf:provisionActivity ?statements}
                )
              }      
            } 
          ]``
        }</http:body>
      </http:request>
    )[2]   
  )
  let $provision-check-dates := (
     http:send-request(
      <http:request
          method="post"
          href="{$targ}"
          username="{$user}"
          password="{$pass}"
          send-authorization="true">
          <http:header
              name="Content-Type"
              value="{$type}; charset=utf-8"/>
          <http:header
              name="Accept"
              value="{$head}"/>
          <http:body
              media-type="{$type}">{
                  ``[
            PREFIX bf: <http://id.loc.gov/ontologies/bibframe/>
            PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
            PREFIX bflc: <http://id.loc.gov/ontologies/bflc/>
            PREFIX svde: <http://share-vde.org/rdfBibframe/>
            PREFIX yul1: <http://library.yale.edu/ld4p/>
            SELECT ?resource ?main
            WHERE { 
              GRAPH <http://library.yale.edu/ld4p> {             
                ?resource a bf:Instance ; 
                          bf:title ?title ;
                          bf:adminMetadata ?admin .
                ?admin bflc:catalogerId ?cat .
                ?title bf:mainTitle ?main .
                FILTER((STR(?cat)) = "`{$netID}`")
                FILTER(                  
                  NOT EXISTS {
                    ?resource bf:provisionActivity ?statements .
                    ?statements <http://www.europeana.eu/schemas/edm/occurredAt> ?time .        
                  }
                )
              }      
            } 
          ]``
        }</http:body>
      </http:request>
    )[2]   
  )
  let $sameAs-check := (
    http:send-request(
      <http:request
          method="post"
          href="{$targ}"
          username="{$user}"
          password="{$pass}"
          send-authorization="true">
          <http:header
              name="Content-Type"
              value="{$type}; charset=utf-8"/>
          <http:header
              name="Accept"
              value="{$head}"/>
          <http:body
              media-type="{$type}">{
                  ``[
            PREFIX bf: <http://id.loc.gov/ontologies/bibframe/>
            PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
            PREFIX bflc: <http://id.loc.gov/ontologies/bflc/>
            PREFIX svde: <http://share-vde.org/rdfBibframe/>
            PREFIX yul1: <http://library.yale.edu/ld4p/>
            SELECT ?resource ?main
            WHERE { 
              GRAPH <http://library.yale.edu/ld4p> {     
                ?resource bf:adminMetadata ?admin ;
                          bf:title ?title ;
                          bf:provisionActivity/bf:contribution/bf:agent/owl:sameAs ?same .
                ?admin bflc:catalogerId ?cat .
                ?title bf:mainTitle ?main .
                FILTER((STR(?cat)) = "`{$netID}`")
                FILTER(!strstarts(?same, "http"))
              }
            } 
          ]``
        }</http:body>
      </http:request>
    )[2]   
  )
return
  <response time="{prof:current-ms() - $start}">
  

        <extent-check>{
          for $result in $extent-check//*:result
          return
            <item copied="false" iri="{$result/*:binding/*:uri}">{$result/*:binding/*:literal/string()}</item>
        }</extent-check>
        <provision-check-statements>{
          for $result in $provision-check-statements//*:result
          return
            <item copied="false" iri="{$result/*:binding/*:uri}">{$result/*:binding/*:literal/string()}</item>
        }</provision-check-statements>

        <provision-check-dates>{
          for $result in $provision-check-dates//*:result
          return
            <item copied="false" iri="{$result/*:binding/*:uri}">{$result/*:binding/*:literal/string()}</item>
        }</provision-check-dates>

        <supplied-check>{
          for $result in $supplied-check//*:result
          return
            <item copied="false" iri="{$result/*:binding/*:uri}">{$result/*:binding/*:literal/string()}</item>
        }</supplied-check>

        <sameAs-check>{
          for $result in $sameAs-check//*:result
          return
            <item copied="false" iri="{$result/*:binding/*:uri}">{$result/*:binding/*:literal/string()}</item>
        }</sameAs-check>
   
  
  </response>

};

declare
%rest:path("/lookups")
%rest:GET
function lookups:redirect(

) as item() {

  web:redirect("/ld4p/2019/lookups")

};


declare
%rest:path("/ld4p/2019/lookups/request/works")
%rest:GET
%rest:query-param("q", "{$q}")
%rest:query-param("lc-index", "{$index}")
%output:method("xml")
function lookups:request-works(
  $q, $index
) as document-node() {

(: "http://id.loc.gov/search/?q=cs:http://id.loc.gov/entities/hubs&amp;q=bola%20de%20cristal&amp;format=atom" :)

  let $start := prof:current-ms()
  let $ns :=
    if ($index eq "work")
    then "http://id.loc.gov/resources/works"
    else "http://id.loc.gov/resources/hubs"
  return
  
  document {
    <response>{      
      let $qs := "http://id.loc.gov/search/?q=cs:" || $ns || "&amp;q=" || encode-for-uri($q) || "&amp;format=atom"
      let $query := doc($qs)
      return (
        <status            
        query-count="{$query/atom:feed/opensearch:totalResults}" qs="{$qs}" start="{$start}" end="{prof:current-ms()}" time="{prof:current-ms() - $start}"/>,        
        for $result in $query//atom:entry
        return
          <item
            copied="false" iri="{$result/atom:link[not(@type)]/@href/data()}" q="{$q}">
            <name>{$result/atom:title/data()}</name>          
          </item>
      )
    }</response>          
  }
  
};


declare
%rest:path("/ld4p/2019/lookups/request/rbms")
%rest:GET
%rest:query-param("q", "{$q}")
%rest:query-param("rbms-index", "{$index}")
%output:method("xml")
function lookups:request-rbms(
  $q, $index
) as document-node() {


  let $start := prof:current-ms()
  
  let $db := substring-before($index, "RbmsKw")
    
  return
  
  document {
    <response type="rbms">{      
      
      let $search :=
        if (normalize-space($q))
        then
          ft:search($db, $q, map {
            "fuzzy": true()
          })/..
        else
          db:open($db)//skos:prefLabel
                       
      for $result in $search
      where name($result) = "skos:prefLabel" and not(contains($result, "Gathering term"))
            
      let $broader := $result/../skos:broader
      let $narrower := $result/../skos:narrower
      
      
      let $recurse-broader :=
        <broaders>{
          lookups:recurse-broader(
            $db, $broader
          )      
        }</broaders>
        
      let $renest-with-splits :=
        <groupings>{
          lookups:renest3(
            <labels>{lookups:renest($recurse-broader)}</labels>
          )
        }</groupings>
      
      let $renest-broader := (
        <levels>{
        
          (:for $level in 
            <levels>{
              lookups:renest($recurse-broader)
            }</levels>/level
          let $labels := $level/label
          return lookups:renest2($labels):)
          
          for $group in $renest-with-splits/groups/group
          return
            lookups:renest2($group//label)
          
        }</levels>
      ) 
      
        
      let $recurse-narrower :=
        <narrowers>{     
          lookups:recurse-narrower(
            $db, $narrower
          )
        }</narrowers>             
      
      let $current-label := data($result)
      let $current-uri := $result/../@rdf:about/data()
      let $current-concat := distinct-values(concat($current-label, "|", $current-uri))
      
      
      
      
     
      return (
                              
          <item
            copied="false" iri="{}" q="{$q}">
            <status            
              query-count="{}" qs="{}" start="{$start}" end="{prof:current-ms()}" time="{prof:current-ms() - $start}"/>        
            
             
              
              
              
              <div class="current-list" data-uri="{$current-uri}">{lookups:make-broader-list($renest-broader, $current-concat, $recurse-narrower)}</div>
              
              
              
              
                      
          </item>
      )
    }</response>          
  }
  
};



declare  function lookups:make-narrower-list(
  $nl
) as item()* {

  if ($nl)
  then
    <ul class="narrower">{
      for $n in $nl/narrower
      return
        <item copied="false" iri="{normalize-space($n/label/@uri)}">{
          normalize-space($n/label),
          if ($n/narrower)
          then
            lookups:make-narrower-list($n)
          else ()                   
        }</item>
    }</ul>

};

declare  function lookups:make-broader-list(
  $bl, $c, $nl
) as item()* {

  if ($bl)
  then
    <ul>{
      for $level in $bl/level
      return
      <item copied="false" class="broader" iri="{$level/label/@uri}">{        
        normalize-space($level/label)
        ,
        if ($level/level)
        then (
          lookups:make-broader-list($level, $c, $nl)                  
        )
        else
          <ul>
            <item copied="false" class="current" iri="{normalize-space(substring-after($c, '|'))}">{
              normalize-space(substring-before($c, "|"))
              ,
              if ($nl/narrower)
                then
                  lookups:make-narrower-list($nl)
                else ()
            }</item>
          </ul>
        
      }</item>
      
    }</ul>
(:  
    <ul>{
      for $level in $bl/level
      return
        <li class="broader" data-uri="{$level/label/@uri}">{        
          data($level/label),
          if ($level/level)
          then (
            lookups:make-broader-list($level, $c, $nl)
          )
          else ( 
            
            
            
            <ul>
              <li class="current" data-uri="{}">{                
                $c,
                if ($nl/narrower)
                then
                  lookups:make-narrower-list($nl)
                else ()
              }</li>
            </ul>
            
          )
        }</li>      
    }</ul>
    :)
  else ()
  
};


declare  function lookups:renest(
  $broaders
) as item()* {
  
    
      for $broader in $broaders/broader
      
      return (
        
        
        if ($broader[./following-sibling::broader or ./preceding-sibling::broader])
        then (
          <split>{<head>{$broader/label}</head>, lookups:renest($broader)}</split>
          
          
          
        )
        else (
          <head>{$broader/label}</head>,
          lookups:renest($broader)
          
        )
        
        
          
            
            
          
            
          
    
      )
  
};

declare  function lookups:renest3(
  $labels
) as item()* {
  
  (:if ($labels//split)
  then (
        
      let $heads := $labels//head[not(ancestor::split)]/label
       
      for $split in $labels//split
      return (
        <labels>{reverse(($heads, $split//label))}</labels> 
      )
     
  ) 
  else
    <labels>{
      reverse($labels//head/label)
    }</labels>:)
  
  if ($labels//split)  
  then
    if ($labels//head[not(ancestor::split)])
    then
      <groups>{
        let $heads := $labels//head[not(ancestor::split)]/label
                              
        for $split in $labels//split
        return (
          <group>{reverse(($heads, $split//label))}</group> 
        )
      }</groups>
      
    else
      for $split in $labels/split
      return (
        if ($split/head/following-sibling::split)
        then
        <groups>{
        
        
          for $fg in $split/head/following-sibling::split
          return (
            <group>{reverse(($split/head/label, $fg//label))}</group>
          )
        
        
        
        }</groups>
        else ( 
          lookups:renest3($split)
        )  
      )
  else
    <groups>
      <group>{reverse($labels//head/label)}</group>
    </groups>
        
      
  
  
  
    
    
    
    
  
  
    
    
  
     
};

declare  function lookups:renest2(
  $labels
) as item()* {
  
  <level>{
    head($labels)
    ,
    if (tail($labels))
    then
      lookups:renest2(tail($labels))
    else ()
  }</level>
    
    
    

    (:if ($labels)
    then
            
      let $labels := $labels//label
      return (
        
          
          <level>{             
            head($labels),
            lookups:renest2(tail($labels))
          }</level>
      )
    else ()
:)            
    
  
};

declare  function lookups:recurse-broader(
  $db, $broader
) as item()* {
  
      if ($broader)
      then        
        for $b in $broader
      
        let $rel :=
          db:attribute($db, $b/@rdf:resource, "rdf:about")/..
          
        return (
        
          <broader>{
            <label uri="{$rel/@rdf:about}">{$rel/skos:prefLabel/data()}</label>
            ,                                                  
            if ($rel/skos:broader)
            then
              lookups:recurse-broader($db, $rel/skos:broader)
            else ()                                  
          }</broader>
          
        )                           
      else ()
      
};

declare  function lookups:recurse-narrower(
  $db, $narrower
) as item()* {
  
      if ($narrower)
      then
        
          for $n in $narrower
          return (
            let $rel :=
              db:attribute($db, $n/@rdf:resource, "rdf:about")/..
            return (
              if ($rel)
              then
                for $r in $rel
                return (
                <narrower>
                  <label uri="{$r/@rdf:about}">{$r/skos:prefLabel/data()}</label>
                  {
                  if ($r/skos:narrower)
                  then
                    lookups:recurse-narrower($db, $r/skos:narrower)
                  else ()
                 }
                 </narrower>
                )
              else ()
            )    
          )      
        
      else ()
      
};


declare
%rest:path("/ld4p/2019/lookups/request")
%rest:GET
%rest:query-param("q", "{$q}")
%rest:query-param("lc-index", "{$index}")
%rest:query-param("max-request", "{$max-request}", 60)
%rest:query-param("max-display", "{$max-display}", 12)
%output:method("xml")
function lookups:request(
$q, $index, $max-request, $max-display
) as document-node() {
  let $start := prof:current-ms()
  return
  document {
    <response>{
        
      let $index-flag := 
        if (ends-with($index, "Kw"))
        then true()
        else false()
       
      let $db :=
        if (not(contains(lower-case($index), "sub")) and not(starts-with($index, "genre")))
        then "naf"
        else "lcsh"
      
      let $query :=
        if (ends-with($index, "Kw"))
        then 
          let $tokens := tokenize($q, "\s+")
          return
            string-join(
              (for $token in $tokens
              return 
                concat("local.", $index, "=%22", encode-for-uri($token), "%22")), "%20and%20"
            )
        else
          concat("local.", $index, "=%22", encode-for-uri($q), "%22")
      let $qs := "https://www.tat2.io/metaproxy/" || $db || "?version=1.1&amp;operation=searchRetrieve&amp;query=" || $query || "&amp;startRecord=1&amp;maximumRecords=" || $max-request || "&amp;recordSchema=marcxml"              
      let $ids :=                    
        doc($qs)//*:datafield[@tag = "010"]/*[@code = "a"]
      
      let $count-results := count($ids)

      let $results := (
        for $id at $p in $ids
        let $name := string-join(($id/../../*[starts-with(@tag, "1")]/*), " ")
        
        let $title-flag :=
          if ($id/../../*[starts-with(@tag, "1")]/*[@code = "t"])
          then true()
          else false()
          
        let $concat :=
          if ($id/../../*:datafield[starts-with(@tag, "15")])
          then
            string-join($id/../../*:datafield[starts-with(@tag, "1")]/*, "--")
          else
            string-join($id/../../*:datafield[starts-with(@tag, "1")]/*, " ")
          
        let $sources := $id/../../*:datafield[@tag = "670"]
        let $info := $id/../../*:datafield[starts-with(@tag, "3")]        
        let $variants := $id/../../*:datafield[starts-with(@tag, "4")]
        
        let $strip := replace($id, "\s+", "")
        
        let $stem := (        
          if ((starts-with($strip, "s") or starts-with($strip, "g")) and ends-with($index, "Kw"))
          then
            ("https://id.loc.gov/authorities/subjects/", "any word")
          else
            if (starts-with($strip, "n") and ends-with($index, "Kw"))
            then
              if (not(starts-with($index, "conf")) and not(contains(lower-case($index), "title")) and $title-flag = false())
              then
                ("https://id.loc.gov/rwo/agents/", "any word")
              else
                ("https://id.loc.gov/authorities/names/", "any word")
            else
              if ((starts-with($strip, "s") or starts-with($strip, "g")) and not(ends-with($index, "Kw")))
              then
                ("https://id.loc.gov/authorities/subjects/", "any word")
              else
                if (starts-with($strip, "n") and not(ends-with($index, "Kw")))
                then
                  if (not(starts-with($index, "conf")) and not(contains(lower-case($index), "title")) and $title-flag = false())
                  then
                    ("https://id.loc.gov/rwo/agents/", "any")
                  else
                    ("https://id.loc.gov/authorities/names/", "any")
                else
                  ()
        ) (: end $stem :)
                      
        where ft:contains($name, $q, map {
          "fuzzy": true(),
          "content": "start",
          "mode": $stem[2]
        }) or (some $v in $variants
          satisfies ft:contains($v, $q, map {
            "fuzzy": true(),
            "content": "start",
            "mode": $stem[2]
          }))               
        
        let $score := ft:score(lower-case($name) contains text {lower-case($q)} any word using fuzzy)
        let $weight := (($score * 100) + count($variants | $sources | $info))        
                
        order by $weight descending
        (:order by count($variants | $sources | $info) descending:)
        (:order by lower-case($name):)
                        
        
        (:
        <info>{
        for $i in $info
        return
          <i>{$i}</i>
        }</info>
        <variants>{
        for $v in $variants
        return
          <v>{$v}</v>
        }</variants>         
        :)
        
      return
        <item
          copied="false" iri="{concat($stem[1], $strip)}" weight="{$weight}" name="{lower-case($name)}" q="{lower-case($q)}">          
          <name>{$concat}</name>  
          <sources>{
            for $s in $sources
            return
              <s>{$s}</s>
          }</sources>
        </item>
      ) (: end $results :)
      
      let $count-filtered := count($results)
      
      let $displayed :=
        for $item at $p in $results
        where $p le xs:integer($max-display)
        order by floor($item/@weight) descending
        return
          $item
      return (
        <status
          filtered-count="{$count-filtered}"
          query-count="{$count-results}" qs="{$qs}" start="{$start}" end="{prof:current-ms()}" time="{prof:current-ms() - $start}"/>
        ,
        $displayed
      )
    }</response>
  }

};

declare
%rest:path("/ld4p/2019/lookups")
%rest:GET
%output:method("xhtml")
%output:media-type("application/xhtml+xml")
function lookups:home(

) as document-node() {
  
  document {
    processing-instruction {"xml-stylesheet"} {
      'type="text/xsl" href="/basex2/static/xphoneforms/build/xsl/xsltforms.xsl"'
    },
    processing-instruction {"xsltforms-options"} {'debug="no"'},
    processing-instruction {"css-conversion"} {'no'}
    ,
    
    <html
      xmlns="http://www.w3.org/1999/xhtml"
      xmlns:ev="http://www.w3.org/2001/xml-events"
      xmlns:h="http://www.w3.org/1999/xhtml"
      xmlns:xf="http://www.w3.org/2002/xforms"
      xmlns:xsd="http://www.w3.org/2001/XMLSchema"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      
      <head>
        <title>Alternative Lookups</title>
        <meta
          name="viewport"
          content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
        
        <style
          type="text/css">
          <![CDATA[
          .cell {padding: 10px;}
          .xforms-switch {margin: 10px;}
          #query-input input {width: 100%;}
          .iri input {width: 300px;}
          #status {color: blue;}
          .blue {border: 1px solid lightblue;}
          .dblue {border: 1px dotted blue;}
  	.copy {margin-right: 10px;}
  	#maxd, #maxr {width: 155px;}
  	#maxd > .value > input {width: 50% !important;}
  	#maxr > .value > input {width: 50% !important;}
  	.xforms-hint {z-index: 500;}
  	.ephemeral {margin-left: 10px;}
  	.bold {font-weight: 800;}
  	#about, #about-content {margin-top: 10px;}
  	#param-row {width: 35%;}
  	.xforms-hint-value {z-index: 500;}
    .red {color: red;}
        ]]>
        </style>
        
        <link
          href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css"
          rel="stylesheet"/>
        <link
          href="/basex2/static/bibframx.css"
          rel="stylesheet"/>
        
        <script
          src="/basex2/static/clipboard.js-master/dist/clipboard.min.js"></script>
        
        <model
          id="m"
          xmlns="http://www.w3.org/2002/xforms">
          
          <instance
            id="state">
            <data
              xmlns="">
              <loading
                status="false">... Loading ...</loading>
              <current/>
              <status/>
            </data>
          </instance>
          
          <instance
            id="params">
            <data
              xmlns="">
              <q></q>
              <indexes>
                <rbms-index></rbms-index>
                <lc-index></lc-index>
              </indexes>              
              <index-type>lc-keyword</index-type>                                             
              <max-request>100</max-request>
              <max-display>50</max-display>
              
            </data>
          </instance>
          
          <instance
            id="response">
            <data
              xmlns="">
              <response/>
            </data>
          </instance>
          
          <submission
            id="send-query"
            ref="instance('params')"
            method="get"
            mode="asynchronous"
            replace="instance"
            instance="response"
            targetref="response"
            resource="/basex2/ld4p/2019/lookups/request">
            <action ev:event="xforms-submit">
              
            </action>
            <action
              ev:event="xforms-submit-done">
              <setvalue
                ref="instance('state')/loading/@status"
                value="'false'"/>
              <setvalue
                ref="instance('params')/max-request"
                value="100"/>
            </action>
          </submission>
          
          <submission
            id="send-query-2"
            ref="instance('params')"
            method="get"
            mode="asynchronous"
            replace="instance"
            instance="response"
            targetref="response"
            resource="/basex2/ld4p/2019/lookups/request/works">
            <action ev:event="xforms-submit">
              
            </action>
            <action
              ev:event="xforms-submit-done">
              <setvalue
                ref="instance('state')/loading/@status"
                value="'false'"/>              
            </action>
          </submission>
          
          <submission
            id="send-query-rbms"
            ref="instance('params')"
            method="get"
            mode="asynchronous"
            replace="instance"
            instance="response"
            targetref="response"
            resource="/basex2/ld4p/2019/lookups/request/rbms">
            <action ev:event="xforms-submit">
              
            </action>
            <action
              ev:event="xforms-submit-done">
              <xf:setvalue ref="instance('state')/status" value="'none'" if="instance('response')/response[not(*)]"/>
              <setvalue
                ref="instance('state')/loading/@status"
                value="'false'"/>              
            </action>
          </submission>

          <action
            ev:event="xforms-ready">
            <setfocus
              control="query-input"/>
          </action>
          
          <action ev:event="copy-event">            
            <setvalue ref="instance('response')/response//item[@iri = instance('state')/current]/@copied" value="'true'"/>
            <dispatch name="copy-change" targetid="m" delay="1000"/>            
          </action>
          
          <action ev:event="copy-change">
            <setvalue ref="instance('response')/response//item[@iri = instance('state')/current]/@copied" value="'false'"/>
          </action>

        </model>
      </head>
      <body>
        <div
          class="container-fluid">
          
          <hr
            class="blue"/>
          
          <h1>Alternative lookups for Sinopia</h1>
          <xf:group id="about">
            <xf:switch>
              <xf:case
                id="hide-info"
                selected="true">
                <xf:trigger
                  class="btn btn-info">
                  <xf:label>About this tool</xf:label>
                  <xf:toggle
                    ev:event="DOMActivate"
                    case="show-info"/>
                </xf:trigger>
              </xf:case>
              <xf:case
                id="show-info"
                selected="false">
                <xf:trigger
                  class="btn btn-info">
                  <xf:label>Hide</xf:label>
                  <xf:toggle
                    ev:event="DOMActivate"
                    case="hide-info"/>
                </xf:trigger>
                <xf:group id="about-content">
                  <p>This "alternative lookups" form is intended to be a temporary workaround for lookup issues currently experienced when using the <a
                      href="https://lookup.ld4l.org/" target="_blank">Questioning Authority</a> (QA) service. Lookups performed using this form should yield better results than those that are currently available using QA.</p>
                  <p class="bold">Disclaimer: this tool uses the Library of Congress's <a href="https://www.loc.gov/z3950/lcserver.html" target="_blank">Z39.50 service</a> and Index Data's <a
                      href="https://www.indexdata.com/resources/software/metaproxy/"
                      target="_blank">metaproxy</a> to perform lookups against Library of Congress authority files. It was created for temporary use in the Yale LD4P project. As such, it is not intended to be a public production service, but anyone is free to use it on an "as is" basis. If you are interested in setting up a similar service or would like to learn more, contact timothy.thompson [at] yale.edu.</p>
                  <p>Some observations about the tool:</p>
                  <ul>
                    <li>Because lookups are being performed directly against LC, results will be up to date.</li>
                    <li>Lookups include the following Library of Congress authorities: 
                      <ul>
                        <li>Persons and Name/Title Headings</li>
                        <li>Corporate Bodies</li>
                        <li>Conference Names</li>
                        <li>Geographic Places</li>
                        <li>Subjects and Subdivisions</li>
                        <li>Genre/Form Terms</li>
                        <li>Uniform Titles</li>                    
                      </ul>                    
                    </li>
                    <li>For each vocabulary, two search options are available: keyword and phrase. Phrase searches are <span class="bold">left-anchored</span> and <span class="bold">right-truncated</span> and work best when the authorized form of a name or term is known.</li>
                    <li>Real World Object (RWO) URIs are used for persons, families, corporate bodies, and places. Note, however, that LC RWO URIs for places do not currently seem to be dereferenceable.</li>
                  </ul>
                  <p class="bold">How to use it:</p>
                  <ul>
                    <li>Select an index type (keyword or phrase)</li>
                    <li>Select an appropriate search index from the drop-down menu.</li>
                    <li>For Name/Title searches, use the "Primary Headings" indexes.</li>
                    <li>Enter a search term and press the "Enter" key or click the "Submit" button. Searches are not case sensitive (e.g., "yale university" and "Yale University" should return the same results).</li>
                    <li>Max request and display parameter can also be tweaked to improve results.</li>
                    <li>If a match is found in the list of results, its id.loc.gov URI can be copied by clicking the "Copy to clipboard" button. This can then be pasted into a lookup field in the Sinopia Linked Data Editor.</li>
                  </ul>
                </xf:group>
              </xf:case>
            </xf:switch>
          </xf:group>
          <hr
            class="blue"/>
          <xf:group
            ref="instance('params')">
            
            <xf:select ref="index-type" appearance="minimal">
              <xf:label>Index Type</xf:label>
              <xf:item>
                <xf:label>RBMS Keyword</xf:label>
                <xf:value>rbms-keyword</xf:value>
              </xf:item>
              <xf:item>
                <xf:label>LC Keyword</xf:label>
                <xf:value>lc-keyword</xf:value>
              </xf:item>
              <xf:item>
                <xf:label>LC Phrase</xf:label>
                <xf:value>lc-phrase</xf:value>
              </xf:item>
              <xf:action ev:event="xforms-value-changed">
                <xf:setvalue ref="../indexes/lc-index" value="''"/>                
                <xf:setvalue ref="../indexes/rbms-index" value="''"/>     
                <xf:delete
                  ref="instance('response')/response/*"/>
              </xf:action>
            </xf:select>
            <br/>
            <br/>
            <xf:input
              id="query-input"
              ref="q"
              incremental="true">
              <xf:label>Query</xf:label>
	      
              <xf:action
                ev:event="DOMActivate" if="../indexes/lc-index[normalize-space(.)] and ../indexes/rbms-index[not(normalize-space(.))]">
                
                <xf:setvalue if="starts-with(instance('params')/indexes/lc-index, 'geo')" ref="instance('params')/max-request" value="200"/>
                                                 
                <xf:setvalue
                  ref="instance('state')/loading/@status"
                  value="'true'"/>
                
                <xf:delete
                  ref="instance('response')/response/*"/>
                                
                <xf:send submission="send-query" if="not(../indexes/lc-index = 'hub' or ../indexes/lc-index = 'work' or normalize-space(../indexes/rbms-index))"/>
                <xf:send submission="send-query-2" if="../indexes/index = 'hub' or ../indexes/index = 'work'"/>                
                    
              </xf:action>
              
              <xf:action
                ev:event="DOMActivate" if="../indexes/rbms-index[normalize-space(.)]">

                <xf:setvalue ref="instance('state')/status" value="''"/>
                
                <xf:setvalue
                  ref="instance('state')/loading/@status"
                  value="'true'"/>
                
                <xf:delete
                  ref="instance('response')/response/*"/>
                                               
                <xf:send submission="send-query-rbms"/>
                    
              </xf:action>
                            

            </xf:input>
            
            <xf:group class="red" ref="indexes[not(normalize-space(lc-index)) and not(normalize-space(rbms-index))]">
            	<h3>Please select an index to search.</h3>
            </xf:group>
                                    
            <xf:select1 ref="indexes/rbms-index[../../index-type = 'rbms-keyword']" appearance="minimal">
              <xf:label>RBMS Indexes</xf:label>
              <xf:item>
                <xf:label>Binding</xf:label>
                <xf:value>bindingRbmsKw</xf:value>
              </xf:item>
              <xf:item>
                <xf:label>Genre</xf:label>
                <xf:value>genreRbmsKw</xf:value>
              </xf:item>
              <xf:item>
                <xf:label>Paper</xf:label>
                <xf:value>paperRbmsKw</xf:value>
              </xf:item>
              <xf:item>
                <xf:label>Printing &amp; Publishing</xf:label>
                <xf:value>printingAndPublishingRbmsKw</xf:value>
              </xf:item>
              <xf:item>
                <xf:label>Provenance</xf:label>
                <xf:value>provenanceRbmsKw</xf:value>
              </xf:item>
              <xf:item>
                <xf:label>Relationship Designators</xf:label>
                <xf:value>relationshipDesignatorsRbmsKw</xf:value>
              </xf:item>
              <xf:item>
                <xf:label>Type</xf:label>
                <xf:value>typeRbmsKw</xf:value>
              </xf:item>
              
            </xf:select1>
            
            <xf:select1
              ref="indexes/lc-index[../../index-type = 'lc-keyword']"
              appearance="minimal">
              <xf:label>LC Keyword Indexes</xf:label>
              <xf:item>
                <xf:label>Any Keyword</xf:label>
                <xf:value>any</xf:value>
              </xf:item>              
              <xf:item>
                <xf:label>Person</xf:label>
                <xf:value>persNameKw</xf:value>
              </xf:item>                                          
              <xf:item>
                <xf:label>Corporate Body</xf:label>
                <xf:value>corpNameKw</xf:value>
              </xf:item>              
              <xf:item>
                <xf:label>Conference</xf:label>
                <xf:value>confNameKw</xf:value>
              </xf:item>              
              <xf:item>
                <xf:label>Geographic Place</xf:label>
                <xf:value>geoNameKw</xf:value>
              </xf:item>              
              <xf:item>
                <xf:label>Genre/Form</xf:label>
                <xf:value>genreFormKw</xf:value>
              </xf:item>              
              <xf:item>
                <xf:label>Subject (All)</xf:label>
                <xf:value>subjectKw</xf:value>
              </xf:item>              
              <xf:item>
                <xf:label>Topical Subject</xf:label>
                <xf:value>topicalSubjectKw</xf:value>
              </xf:item>              
              <xf:item>
                <xf:label>Topical Subdivision</xf:label>
                <xf:value>genSubdivKw</xf:value>
              </xf:item>              
              <xf:item>
                <xf:label>Geographic Subdivision</xf:label>
                <xf:value>geoSubdivKw</xf:value>
              </xf:item>              
              <xf:item>
                <xf:label>Chronological Subdivision</xf:label>
                <xf:value>chronSubdivKw</xf:value>
              </xf:item>              
              <xf:item>
                <xf:label>Form Subdivision</xf:label>
                <xf:value>formSubdivKw</xf:value>
              </xf:item>   
              <xf:item>
                <xf:label>Primary Heading (Name/Title)</xf:label>
                <xf:value>primaryKw</xf:value>
              </xf:item>              
              <xf:item>
                <xf:label>Uniform Title</xf:label>
                <xf:value>uniformTitleKw</xf:value>
              </xf:item>                                          
              <xf:item>
                <xf:label>BF Hub</xf:label>
                <xf:value>hub</xf:value>
              </xf:item>
              <xf:item>
                <xf:label>BF Work</xf:label>
                <xf:value>work</xf:value>
              </xf:item>
              
            </xf:select1>
            

            
            <xf:select1
              ref="indexes/lc-index[../../index-type = 'lc-phrase']"
              appearance="minimal">
              <xf:label>LC Phrase Indexes</xf:label>
              <xf:item>
                <xf:label>Person</xf:label>
                <xf:value>persName</xf:value>
              </xf:item>                            
              <xf:item>
                <xf:label>Corporate Body</xf:label>
                <xf:value>corpName</xf:value>
              </xf:item>
              <xf:item>
                <xf:label>Conference</xf:label>
                <xf:value>confName</xf:value>
              </xf:item>
              <xf:item>
                <xf:label>Geographic Place</xf:label>
                <xf:value>geoName</xf:value>
              </xf:item>
              <xf:item>
                <xf:label>Genre/Form</xf:label>
                <xf:value>genreForm</xf:value>
              </xf:item>
              <xf:item>
                <xf:label>Subject (All)</xf:label>
                <xf:value>subject</xf:value>
              </xf:item>
              <xf:item>
                <xf:label>Topical Subject</xf:label>
                <xf:value>topicalSubject</xf:value>
              </xf:item>
              <xf:item>
                <xf:label>Topical Subdivision</xf:label>
                <xf:value>genSubdiv</xf:value>
              </xf:item>
              <xf:item>
                <xf:label>Geographic Subdivision</xf:label>
                <xf:value>geoSubdiv</xf:value>
              </xf:item>
              <xf:item>
                <xf:label>Chronological Subdivision</xf:label>
                <xf:value>chronSubdiv</xf:value>
              </xf:item>
              <xf:item>
                <xf:label>Form Subdivision</xf:label>
                <xf:value>formSubdiv</xf:value>
              </xf:item>
              <xf:item>
                <xf:label>Primary Heading (Name/Title)</xf:label>
                <xf:value>primary</xf:value>
              </xf:item>              
              <xf:item>
                <xf:label>Uniform Title</xf:label>
                <xf:value>uniformTitle</xf:value>
              </xf:item>            
            </xf:select1>
            
            <br/>
            <br/>
            <div id="param-row" class="row">
              <div class="col-md-6">
                <xf:input
                  id="maxr"
                  ref="max-request">
                  <xf:label>Max request</xf:label>
                  <xf:hint>Maximum number of records to request on the back end. Records will be filtered for relevance. Increase this value if no relevant results are returned. With searches for geographic places, this value with automatically be increased to 200.</xf:hint>
                </xf:input>
              </div>
              <div class="col-md-6">
                <xf:input
                  id="maxd"
                  ref="max-display">
                  <xf:label>Max display</xf:label>
                  <xf:hint>Maximum number of results to display</xf:hint>
                </xf:input>
              </div>
            </div>
            <xf:trigger              
              class="btn btn-primary">
              <xf:label>Submit</xf:label>
              <xf:action
                ev:event="DOMActivate" if="indexes/lc-index[normalize-space(.)]">
                
                
                
                <xf:setvalue if="starts-with(instance('params')/indexes/lc-index, 'geo')" ref="instance('params')/max-request" value="200"/>
                
                <xf:delete
                  ref="instance('response')/response/*"/>                
                
                <xf:setvalue
                  ref="instance('state')/loading/@status"
                  value="'true'"/>                               
                  
                <xf:send submission="send-query" if="not(indexes/lc-index = 'hub' or indexes/lc-index = 'work' or normalize-space(indexes/rbms-index))"/>
                <xf:send submission="send-query-2" if="indexes/index = 'hub' or indexes/index = 'work'"/>
                
              </xf:action>
              
              <xf:action
                ev:event="DOMActivate" if="indexes/rbms-index[normalize-space(.)]">

              <xf:setvalue ref="instance('state')/status" value="''"/>
              
              <xf:delete
                  ref="instance('response')/response/*"/>

      
  
                <xf:setvalue
                  ref="instance('state')/loading/@status"
                  value="'true'"/>
                
                
                                               
                <xf:send submission="send-query-rbms"/>
                    
              </xf:action>
              
            </xf:trigger>
                        
          </xf:group>
          
          <hr
            class="blue"/>
          
          <h4>
              <xf:output
                class="status"
                ref="instance('state')/loading[@status = 'true']"/>
          </h4>
          
          <xf:group ref="instance('params')/index-type[contains(., 'rbms')]">
          
            <h4>Hits for your search term will be <span style="padding: 1px; border: dotted blue 1px;">highlighted</span> below. When you search for an individual term (such as "alum"), a full-text search will be executed, and each hit will be returned in context, with broader and narrower terms. Because some terms have multiple broader or narrower terms, they will be repeated for each context.</h4>
           
           <hr class="blue"/>
            	
          </xf:group>
          
          <xf:group
            ref="instance('response')/response[@type = 'rbms']">
            <br/>
            <xf:group ref=".[not(*)][instance('params')/index-type[contains(., 'rbms')]][instance('state')/status[. = 'none']]">
              <h4 class="red">No results for your search. Please confirm that you have selected the correct RBMS index.</h4>
            </xf:group>
            
          
            <xf:repeat ref="item/div/ul/item">
              
              <xf:repeat ref="descendant-or-self::item[normalize-space(@iri)]">
              
                <xf:var name="ancount" value="count(ancestor::item)"/>  
                <div style="margin-left: {{$ancount}}%;">
                
                  <table>
                  
                    <tr>
                      <td class="cell">
                        <h4 style="{{choose(@class = 'current', 'font-weight: 800; border: dotted blue 1px; padding: 5px;', 'font-weight: 500;')}}">
                          <xf:output value="text()"/>
                        </h4>
                      </td>
                      <td class="cell">
                        <a
                          href="{{@iri}}"
                          class="copy"
                          target="_blank">
                          <xf:output
                            value="@iri"/>
                        </a>
                      </td>
                      <td class="cell">
                        <button
                          class="btn btn-primary copy-this"
                          data-clipboard-text="{{@iri}}">Copy to clipboard</button>
                      </td>
                      <td class="cell">
                        <xf:output class="ephemeral" value="choose(.[@copied = 'true'], 'Copied!', '')"/>
                      </td>
                    </tr>
                  
                  </table>
                  

              </div>
                
              
              </xf:repeat>
                
                <hr id="rbms-row" class="blue"/>
                
            </xf:repeat>
          
            
          </xf:group>
          
          <xf:group
            ref="instance('response')/response[not(@type = 'rbms')]">
            
            
            <xf:group
              ref=".[*][not(instance('params')/indexes/lc-index = 'hub') and not(instance('params')/indexes/lc-index = 'work')]">
              <xf:output
                value="concat('Retrieved ', status/@query-count, ' records, filtered to ', status/@filtered-count, 
                choose(
                  instance('params')/max-display &lt; status/@filtered-count, concat(', displaying ', instance('params')/max-display), concat(', displaying ', status/@filtered-count)
                ), '. Executed in ', status/@time, ' milliseconds.')
              "/>
            </xf:group>
            
            <xf:group
              ref=".[*][instance('params')/indexes/lc-index = 'hub' or instance('params')/indexes/lc-index = 'work']">
              <xf:output
                value="concat('Retrieved ', status/@query-count, ' records. Executed in ', status/@time, ' milliseconds.')"/>            
            </xf:group>
            
            <hr
              class="blue"/>
            
            <xf:repeat
              ref="item">
              
              
              <h4>
                <xf:output
                  value="name"/>
              </h4>
              
              <a
                href="{{@iri}}"
                class="copy"
                target="_blank">
                <xf:output
                  value="@iri"/>
              </a>
              
              
                <button
                    class="btn btn-primary copy-this"
                    data-clipboard-text="{{@iri}}">Copy to clipboard</button>                                         
              
               
               <xf:output class="ephemeral" value="choose(.[@copied = 'true'], 'Copied!', '')"/>                                
              
            
              <xf:group
                ref="sources[*]"
                style="margin-left: 15px;">
                <h4>Sources</h4>
                <ul>
                  <xf:repeat
                    ref="s/*:datafield">
                    <li>
                      <xf:output
                        value="."/>
                    </li>
                  </xf:repeat>
                </ul>
                <br/>
              </xf:group>
              <hr
                class="dblue"/>
            
            </xf:repeat>
          </xf:group>
        </div>
        <script>
          <![CDATA[
          
          var clipboard = new ClipboardJS('.copy-this');         

          clipboard.on('success', function(e) {
              console.info('Action:', e.action);
              console.info('Text:', e.text);
              console.info('Trigger:', e.trigger);
          
              e.clearSelection();
              
              var model = document.getElementById("m");
              var state = model.getInstanceDocument("state");
              var current = state.getElementsByTagName('current')[0];
                    
              // Update XForms instance using XSLTForms methods.
                    
              XsltForms_browser.setValue(current, e.text || "");
                                                                                                
              document.getElementById(XsltForms_browser.getMeta(current.ownerDocument.documentElement, "model")).xfElement.addChange(current);          
          
              XsltForms_xmlevents.dispatch(model, "xforms-value-changed");
              XsltForms_xmlevents.dispatch(model, "copy-event");
              XsltForms_xmlevents.dispatch(model, "xforms-rebuild");                        
              XsltForms_globals.refresh();
              
              
              
          
          });
          
          clipboard.on('error', function(e) {
              console.error('Action:', e.action);
              console.error('Trigger:', e.trigger);
          });

        ]]>
        </script>
        <script
          crossorigin="anonymous"
          integrity="sha256-BbhdlvQf/xTY9gja0Dq3HiwQF8LaCRTXxZKRutelT44="
          src="https://code.jquery.com/jquery-2.2.4.min.js"
          type="text/javascript"></script>
        <script
          src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"
          type="text/javascript"></script>
      </body>
    </html>
    
  }
};

declare
%rest:path("/ld4p/2019/lookups-test")
%rest:GET
%output:method("xhtml")
%output:media-type("application/xhtml+xml")
function lookups:home-test(

) as document-node() {
  
  document {
    processing-instruction {"xml-stylesheet"} {
      'type="text/xsl" href="/basex2/static/xsltforms.xsl"'
    },
    processing-instruction {"xsltforms-options"} {'debug="no"'},
    processing-instruction {"css-conversion"} {'no'}
    ,
    
    <html
      xmlns="http://www.w3.org/1999/xhtml"
      xmlns:ev="http://www.w3.org/2001/xml-events"
      xmlns:h="http://www.w3.org/1999/xhtml"
      xmlns:xf="http://www.w3.org/2002/xforms"
      xmlns:xsd="http://www.w3.org/2001/XMLSchema"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      
      <head>
        <title>Alternative Lookups</title>
        <meta
          name="viewport"
          content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
        
        <style
          type="text/css">
          <![CDATA[
          .cell {padding: 10px;}
          .xforms-switch {margin: 10px;}
          #query-input input {width: 100%;}
          .iri input {width: 300px;}
          #status {color: blue;}
          .blue {border: 1px solid lightblue;}
          .dblue {border: 1px dotted blue;}
  	.copy {margin-right: 10px;}
  	#maxd, #maxr {width: 155px;}
  	#maxd > .value > input {width: 50% !important;}
  	#maxr > .value > input {width: 50% !important;}
  	.xforms-hint {z-index: 500;}
  	.ephemeral {margin-left: 10px;}
  	.bold {font-weight: 800;}
  	#about, #about-content {margin-top: 10px;}
  	#param-row {width: 35%;}
  	.xforms-hint-value {z-index: 500;}
    .red {color: red;}
        ]]>
        </style>
        
        <link
          href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css"
          rel="stylesheet"/>
        <link
          href="/basex2/static/bibframx.css"
          rel="stylesheet"/>
        
        <script
          src="/basex2/static/clipboard.js-master/dist/clipboard.min.js"></script>
        
        <model
          id="m"
          xmlns="http://www.w3.org/2002/xforms">
          
          <instance
            id="state">
            <data
              xmlns="">
              <loading
                status="false">... Loading ...</loading>
              <current/>
              <status/>
            </data>
          </instance>
          
          <instance
            id="params">
            <data
              xmlns="">
              <q>alum</q>
              <indexes>
                <rbms-index>bindingRbmsKw</rbms-index>
                <lc-index></lc-index>
              </indexes>              
              <index-type>rbms-keyword</index-type>                                             
              <max-request>100</max-request>
              <max-display>50</max-display>
              
            </data>
          </instance>
          
          <instance
            id="response">
            <data
              xmlns="">
              <response/>
            </data>
          </instance>
          
          <submission
            id="send-query"
            ref="instance('params')"
            method="get"
            mode="asynchronous"
            replace="instance"
            instance="response"
            targetref="response"
            resource="/basex2/ld4p/2019/lookups/request">
            <action ev:event="xforms-submit">
              
            </action>
            <action
              ev:event="xforms-submit-done">
              <setvalue
                ref="instance('state')/loading/@status"
                value="'false'"/>
              <setvalue
                ref="instance('params')/max-request"
                value="100"/>
            </action>
          </submission>
          
          <submission
            id="send-query-2"
            ref="instance('params')"
            method="get"
            mode="asynchronous"
            replace="instance"
            instance="response"
            targetref="response"
            resource="/basex2/ld4p/2019/lookups/request/works">
            <action ev:event="xforms-submit">
              
            </action>
            <action
              ev:event="xforms-submit-done">
              <setvalue
                ref="instance('state')/loading/@status"
                value="'false'"/>              
            </action>
          </submission>
          
          <submission
            id="send-query-rbms"
            ref="instance('params')"
            method="get"
            mode="asynchronous"
            replace="instance"
            instance="response"
            targetref="response"
            resource="/basex2/ld4p/2019/lookups/request/rbms">
            <action ev:event="xforms-submit">
              
            </action>
            <action
              ev:event="xforms-submit-done">
              <xf:setvalue ref="instance('state')/status" value="'none'" if="instance('response')/response[not(*)]"/>
              <setvalue
                ref="instance('state')/loading/@status"
                value="'false'"/>              
            </action>
          </submission>

          <action
            ev:event="xforms-ready">
            <setfocus
              control="query-input"/>
          </action>
          
          <action ev:event="copy-event">            
            <setvalue ref="instance('response')/response//item[@iri = instance('state')/current]/@copied" value="'true'"/>
            <dispatch name="copy-change" targetid="m" delay="1000"/>            
          </action>
          
          <action ev:event="copy-change">
            <setvalue ref="instance('response')/response//item[@iri = instance('state')/current]/@copied" value="'false'"/>
          </action>

        </model>
      </head>
      <body>
        <div
          class="container-fluid">
          
          <hr
            class="blue"/>
          
          <h1>Alternative lookups for Sinopia</h1>
          <xf:group id="about">
            <xf:switch>
              <xf:case
                id="hide-info"
                selected="true">
                <xf:trigger
                  class="btn btn-info">
                  <xf:label>About this tool</xf:label>
                  <xf:toggle
                    ev:event="DOMActivate"
                    case="show-info"/>
                </xf:trigger>
              </xf:case>
              <xf:case
                id="show-info"
                selected="false">
                <xf:trigger
                  class="btn btn-info">
                  <xf:label>Hide</xf:label>
                  <xf:toggle
                    ev:event="DOMActivate"
                    case="hide-info"/>
                </xf:trigger>
                <xf:group id="about-content">
                  <p>This "alternative lookups" form is intended to be a temporary workaround for lookup issues currently experienced when using the <a
                      href="https://lookup.ld4l.org/" target="_blank">Questioning Authority</a> (QA) service. Lookups performed using this form should yield better results than those that are currently available using QA.</p>
                  <p class="bold">Disclaimer: this tool uses the Library of Congress's <a href="https://www.loc.gov/z3950/lcserver.html" target="_blank">Z39.50 service</a> and Index Data's <a
                      href="https://www.indexdata.com/resources/software/metaproxy/"
                      target="_blank">metaproxy</a> to perform lookups against Library of Congress authority files. It was created for temporary use in the Yale LD4P project. As such, it is not intended to be a public production service, but anyone is free to use it on an "as is" basis. If you are interested in setting up a similar service or would like to learn more, contact timothy.thompson [at] yale.edu.</p>
                  <p>Some observations about the tool:</p>
                  <ul>
                    <li>Because lookups are being performed directly against LC, results will be up to date.</li>
                    <li>Lookups include the following Library of Congress authorities: 
                      <ul>
                        <li>Persons and Name/Title Headings</li>
                        <li>Corporate Bodies</li>
                        <li>Conference Names</li>
                        <li>Geographic Places</li>
                        <li>Subjects and Subdivisions</li>
                        <li>Genre/Form Terms</li>
                        <li>Uniform Titles</li>                    
                      </ul>                    
                    </li>
                    <li>For each vocabulary, two search options are available: keyword and phrase. Phrase searches are <span class="bold">left-anchored</span> and <span class="bold">right-truncated</span> and work best when the authorized form of a name or term is known.</li>
                    <li>Real World Object (RWO) URIs are used for persons, families, corporate bodies, and places. Note, however, that LC RWO URIs for places do not currently seem to be dereferenceable.</li>
                  </ul>
                  <p class="bold">How to use it:</p>
                  <ul>
                    <li>Select an index type (keyword or phrase)</li>
                    <li>Select an appropriate search index from the drop-down menu.</li>
                    <li>For Name/Title searches, use the "Primary Headings" indexes.</li>
                    <li>Enter a search term and press the "Enter" key or click the "Submit" button. Searches are not case sensitive (e.g., "yale university" and "Yale University" should return the same results).</li>
                    <li>Max request and display parameter can also be tweaked to improve results.</li>
                    <li>If a match is found in the list of results, its id.loc.gov URI can be copied by clicking the "Copy to clipboard" button. This can then be pasted into a lookup field in the Sinopia Linked Data Editor.</li>
                  </ul>
                </xf:group>
              </xf:case>
            </xf:switch>
          </xf:group>
          <hr
            class="blue"/>
          <xf:group
            ref="instance('params')">
            
            <xf:select ref="index-type" appearance="minimal">
              <xf:label>Index Type</xf:label>
              <xf:item>
                <xf:label>RBMS Keyword</xf:label>
                <xf:value>rbms-keyword</xf:value>
              </xf:item>
              <xf:item>
                <xf:label>LC Keyword</xf:label>
                <xf:value>lc-keyword</xf:value>
              </xf:item>
              <xf:item>
                <xf:label>LC Phrase</xf:label>
                <xf:value>lc-phrase</xf:value>
              </xf:item>
              <xf:action ev:event="xforms-value-changed">
                <xf:setvalue ref="../indexes/lc-index" value="''"/>                
                <xf:setvalue ref="../indexes/rbms-index" value="''"/>     
                <xf:delete
                  ref="instance('response')/response/*"/>
              </xf:action>
            </xf:select>
            <br/>
            <br/>
            <xf:input
              id="query-input"
              ref="q"
              incremental="true">
              <xf:label>Query</xf:label>
	      
              <xf:action
                ev:event="DOMActivate" if="../indexes/lc-index[normalize-space(.)] and ../indexes/rbms-index[not(normalize-space(.))]">
                
                <xf:setvalue if="starts-with(instance('params')/indexes/lc-index, 'geo')" ref="instance('params')/max-request" value="200"/>
                                                 
                <xf:setvalue
                  ref="instance('state')/loading/@status"
                  value="'true'"/>
                
                <xf:delete
                  ref="instance('response')/response/*"/>
                                
                <xf:send submission="send-query" if="not(../indexes/lc-index = 'hub' or ../indexes/lc-index = 'work' or normalize-space(../indexes/rbms-index))"/>
                <xf:send submission="send-query-2" if="../indexes/index = 'hub' or ../indexes/index = 'work'"/>                
                    
              </xf:action>
              
              <xf:action
                ev:event="DOMActivate" if="../indexes/rbms-index[normalize-space(.)]">

                <xf:setvalue ref="instance('state')/status" value="''"/>
                
                <xf:setvalue
                  ref="instance('state')/loading/@status"
                  value="'true'"/>
                
                <xf:delete
                  ref="instance('response')/response/*"/>
                                               
                <xf:send submission="send-query-rbms"/>
                    
              </xf:action>
                            

            </xf:input>
            
            <xf:group class="red" ref="indexes[not(normalize-space(lc-index)) and not(normalize-space(rbms-index))]">
            	<h3>Please select an index to search.</h3>
            </xf:group>
                                    
            <xf:select1 ref="indexes/rbms-index[../../index-type = 'rbms-keyword']" appearance="minimal">
              <xf:label>RBMS Indexes</xf:label>
              <xf:item>
                <xf:label>Binding</xf:label>
                <xf:value>bindingRbmsKw</xf:value>
              </xf:item>
              <xf:item>
                <xf:label>Genre</xf:label>
                <xf:value>genreRbmsKw</xf:value>
              </xf:item>
              <xf:item>
                <xf:label>Paper</xf:label>
                <xf:value>paperRbmsKw</xf:value>
              </xf:item>
              <xf:item>
                <xf:label>Printing &amp; Publishing</xf:label>
                <xf:value>printingAndPublishingRbmsKw</xf:value>
              </xf:item>
              <xf:item>
                <xf:label>Provenance</xf:label>
                <xf:value>provenanceRbmsKw</xf:value>
              </xf:item>
              <xf:item>
                <xf:label>Relationship Designators</xf:label>
                <xf:value>relationshipDesignatorsRbmsKw</xf:value>
              </xf:item>
              <xf:item>
                <xf:label>Type</xf:label>
                <xf:value>typeRbmsKw</xf:value>
              </xf:item>
              
            </xf:select1>
            
            <xf:select1
              ref="indexes/lc-index[../../index-type = 'lc-keyword']"
              appearance="minimal">
              <xf:label>LC Keyword Indexes</xf:label>
              <xf:item>
                <xf:label>Any Keyword</xf:label>
                <xf:value>any</xf:value>
              </xf:item>              
              <xf:item>
                <xf:label>Person</xf:label>
                <xf:value>persNameKw</xf:value>
              </xf:item>                                          
              <xf:item>
                <xf:label>Corporate Body</xf:label>
                <xf:value>corpNameKw</xf:value>
              </xf:item>              
              <xf:item>
                <xf:label>Conference</xf:label>
                <xf:value>confNameKw</xf:value>
              </xf:item>              
              <xf:item>
                <xf:label>Geographic Place</xf:label>
                <xf:value>geoNameKw</xf:value>
              </xf:item>              
              <xf:item>
                <xf:label>Genre/Form</xf:label>
                <xf:value>genreFormKw</xf:value>
              </xf:item>              
              <xf:item>
                <xf:label>Subject (All)</xf:label>
                <xf:value>subjectKw</xf:value>
              </xf:item>              
              <xf:item>
                <xf:label>Topical Subject</xf:label>
                <xf:value>topicalSubjectKw</xf:value>
              </xf:item>              
              <xf:item>
                <xf:label>Topical Subdivision</xf:label>
                <xf:value>genSubdivKw</xf:value>
              </xf:item>              
              <xf:item>
                <xf:label>Geographic Subdivision</xf:label>
                <xf:value>geoSubdivKw</xf:value>
              </xf:item>              
              <xf:item>
                <xf:label>Chronological Subdivision</xf:label>
                <xf:value>chronSubdivKw</xf:value>
              </xf:item>              
              <xf:item>
                <xf:label>Form Subdivision</xf:label>
                <xf:value>formSubdivKw</xf:value>
              </xf:item>   
              <xf:item>
                <xf:label>Primary Heading (Name/Title)</xf:label>
                <xf:value>primaryKw</xf:value>
              </xf:item>              
              <xf:item>
                <xf:label>Uniform Title</xf:label>
                <xf:value>uniformTitleKw</xf:value>
              </xf:item>                                          
              <xf:item>
                <xf:label>BF Hub</xf:label>
                <xf:value>hub</xf:value>
              </xf:item>
              <xf:item>
                <xf:label>BF Work</xf:label>
                <xf:value>work</xf:value>
              </xf:item>
              
            </xf:select1>
            

            
            <xf:select1
              ref="indexes/lc-index[../../index-type = 'lc-phrase']"
              appearance="minimal">
              <xf:label>LC Phrase Indexes</xf:label>
              <xf:item>
                <xf:label>Person</xf:label>
                <xf:value>persName</xf:value>
              </xf:item>                            
              <xf:item>
                <xf:label>Corporate Body</xf:label>
                <xf:value>corpName</xf:value>
              </xf:item>
              <xf:item>
                <xf:label>Conference</xf:label>
                <xf:value>confName</xf:value>
              </xf:item>
              <xf:item>
                <xf:label>Geographic Place</xf:label>
                <xf:value>geoName</xf:value>
              </xf:item>
              <xf:item>
                <xf:label>Genre/Form</xf:label>
                <xf:value>genreForm</xf:value>
              </xf:item>
              <xf:item>
                <xf:label>Subject (All)</xf:label>
                <xf:value>subject</xf:value>
              </xf:item>
              <xf:item>
                <xf:label>Topical Subject</xf:label>
                <xf:value>topicalSubject</xf:value>
              </xf:item>
              <xf:item>
                <xf:label>Topical Subdivision</xf:label>
                <xf:value>genSubdiv</xf:value>
              </xf:item>
              <xf:item>
                <xf:label>Geographic Subdivision</xf:label>
                <xf:value>geoSubdiv</xf:value>
              </xf:item>
              <xf:item>
                <xf:label>Chronological Subdivision</xf:label>
                <xf:value>chronSubdiv</xf:value>
              </xf:item>
              <xf:item>
                <xf:label>Form Subdivision</xf:label>
                <xf:value>formSubdiv</xf:value>
              </xf:item>
              <xf:item>
                <xf:label>Primary Heading (Name/Title)</xf:label>
                <xf:value>primary</xf:value>
              </xf:item>              
              <xf:item>
                <xf:label>Uniform Title</xf:label>
                <xf:value>uniformTitle</xf:value>
              </xf:item>            
            </xf:select1>
            
            <br/>
            <br/>
            <div id="param-row" class="row">
              <div class="col-md-6">
                <xf:input
                  id="maxr"
                  ref="max-request">
                  <xf:label>Max request</xf:label>
                  <xf:hint>Maximum number of records to request on the back end. Records will be filtered for relevance. Increase this value if no relevant results are returned. With searches for geographic places, this value with automatically be increased to 200.</xf:hint>
                </xf:input>
              </div>
              <div class="col-md-6">
                <xf:input
                  id="maxd"
                  ref="max-display">
                  <xf:label>Max display</xf:label>
                  <xf:hint>Maximum number of results to display</xf:hint>
                </xf:input>
              </div>
            </div>
            <xf:trigger              
              class="btn btn-primary">
              <xf:label>Submit</xf:label>
              <xf:action
                ev:event="DOMActivate" if="indexes/lc-index[normalize-space(.)]">
                
                
                
                <xf:setvalue if="starts-with(instance('params')/indexes/lc-index, 'geo')" ref="instance('params')/max-request" value="200"/>
                
                <xf:delete
                  ref="instance('response')/response/*"/>                
                
                <xf:setvalue
                  ref="instance('state')/loading/@status"
                  value="'true'"/>                               
                  
                <xf:send submission="send-query" if="not(indexes/lc-index = 'hub' or indexes/lc-index = 'work' or normalize-space(indexes/rbms-index))"/>
                <xf:send submission="send-query-2" if="indexes/index = 'hub' or indexes/index = 'work'"/>
                
              </xf:action>
              
              <xf:action
                ev:event="DOMActivate" if="indexes/rbms-index[normalize-space(.)]">

              <xf:setvalue ref="instance('state')/status" value="''"/>
              
              <xf:delete
                  ref="instance('response')/response/*"/>

      
  
                <xf:setvalue
                  ref="instance('state')/loading/@status"
                  value="'true'"/>
                
                
                                               
                <xf:send submission="send-query-rbms"/>
                    
              </xf:action>
              
            </xf:trigger>
                        
          </xf:group>
          
          <hr
            class="blue"/>
          
          <h4>
              <xf:output
                class="status"
                ref="instance('state')/loading[@status = 'true']"/>
          </h4>
          
          <xf:group ref="instance('params')/index-type[contains(., 'rbms')]">
          
            <h4>Hits for your search term will be <span style="padding: 1px; border: dotted blue 1px;">highlighted</span> below. When you search for an individual term (such as "alum"), a full-text search will be executed, and each hit will be returned in context, with broader and narrower terms. Because some terms have multiple broader or narrower terms, they will be repeated for each context.</h4>
           
           <hr class="blue"/>
            	
          </xf:group>
          
          <xf:group
            ref="instance('response')/response[@type = 'rbms']">
            <br/>
            <xf:group ref=".[not(*)][instance('params')/index-type[contains(., 'rbms')]][instance('state')/status[. = 'none']]">
              <h4 class="red">No results for your search. Please confirm that you have selected the correct RBMS index.</h4>
            </xf:group>
            
          
            <xf:repeat ref="item/div/ul/item[normalize-space(@iri)]">
              
              <xf:repeat ref="descendant-or-self::item[normalize-space(@iri)]">
              
                  
                <div style="margin-left: {{count(ancestor::item)}}%;">
                
                  <table>
                  
                    <tr>
                      <td class="cell">
                        <h4 style="{{choose(@class = 'current', 'font-weight: 800; border: dotted blue 1px; padding: 5px;', 'font-weight: 500;')}}">
                          <xf:output value="text()"/>
                        </h4>
                      </td>
                      <td class="cell">
                        <a
                          href="{{@iri}}"
                          class="copy"
                          target="_blank">
                          <xf:output
                            value="@iri"/>
                        </a>
                      </td>
                      <td class="cell">
                        <button
                          class="btn btn-primary copy-this"
                          data-clipboard-text="{{@iri}}">Copy to clipboard</button>
                      </td>
                      <td class="cell">
                        <xf:output class="ephemeral" value="choose(.[@copied = 'true'], 'Copied!', '')"/>
                      </td>
                    </tr>
                  
                  </table>
                  

              </div>
                
              
              </xf:repeat>
                
                <hr id="rbms-row" class="blue"/>
                
            </xf:repeat>
          
            
          </xf:group>
          
          <xf:group
            ref="instance('response')/response[not(@type = 'rbms')]">
            
            
            <xf:group
              ref=".[*][not(instance('params')/indexes/lc-index = 'hub') and not(instance('params')/indexes/lc-index = 'work')]">
              <xf:output
                value="concat('Retrieved ', status/@query-count, ' records, filtered to ', status/@filtered-count, 
                choose(
                  instance('params')/max-display &lt; status/@filtered-count, concat(', displaying ', instance('params')/max-display), concat(', displaying ', status/@filtered-count)
                ), '. Executed in ', status/@time, ' milliseconds.')
              "/>
            </xf:group>
            
            <xf:group
              ref=".[*][instance('params')/indexes/lc-index = 'hub' or instance('params')/indexes/lc-index = 'work']">
              <xf:output
                value="concat('Retrieved ', status/@query-count, ' records. Executed in ', status/@time, ' milliseconds.')"/>            
            </xf:group>
            
            <hr
              class="blue"/>
            
            <xf:repeat
              ref="item">
              
              
              <h4>
                <xf:output
                  value="name"/>
              </h4>
              
              <a
                href="{{@iri}}"
                class="copy"
                target="_blank">
                <xf:output
                  value="@iri"/>
              </a>
              
              
                <button
                    class="btn btn-primary copy-this"
                    data-clipboard-text="{{@iri}}">Copy to clipboard</button>                                         
              
               
               <xf:output class="ephemeral" value="choose(.[@copied = 'true'], 'Copied!', '')"/>                                
              
            
              <xf:group
                ref="sources[*]"
                style="margin-left: 15px;">
                <h4>Sources</h4>
                <ul>
                  <xf:repeat
                    ref="s/*:datafield">
                    <li>
                      <xf:output
                        value="."/>
                    </li>
                  </xf:repeat>
                </ul>
                <br/>
              </xf:group>
              <hr
                class="dblue"/>
            
            </xf:repeat>
          </xf:group>
        </div>
        <script>
          <![CDATA[
          
          var clipboard = new ClipboardJS('.copy-this');         

          clipboard.on('success', function(e) {
              console.info('Action:', e.action);
              console.info('Text:', e.text);
              console.info('Trigger:', e.trigger);
          
              e.clearSelection();
              
              var model = document.getElementById("m");
              var state = model.getInstanceDocument("state");
              var current = state.getElementsByTagName('current')[0];
                    
              // Update XForms instance using XSLTForms methods.
                    
              XsltForms_browser.setValue(current, e.text || "");
                                                                                                
              document.getElementById(XsltForms_browser.getMeta(current.ownerDocument.documentElement, "model")).xfElement.addChange(current);          
          
              XsltForms_xmlevents.dispatch(model, "xforms-value-changed");
              XsltForms_xmlevents.dispatch(model, "copy-event");
              XsltForms_xmlevents.dispatch(model, "xforms-rebuild");                        
              XsltForms_globals.refresh();
              
              
              
          
          });
          
          clipboard.on('error', function(e) {
              console.error('Action:', e.action);
              console.error('Trigger:', e.trigger);
          });

        ]]>
        </script>
        <script
          crossorigin="anonymous"
          integrity="sha256-BbhdlvQf/xTY9gja0Dq3HiwQF8LaCRTXxZKRutelT44="
          src="https://code.jquery.com/jquery-2.2.4.min.js"
          type="text/javascript"></script>
        <script
          src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"
          type="text/javascript"></script>
      </body>
    </html>
    
  }
};