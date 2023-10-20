SELECT 
    DISTINCT(SUBSTRING_INDEX(ExtractValue(xml_doc, '//catalog//book//author'), ' ', 2))  AS author
FROM catalogs
ORDER BY author;

/*
Here's how the xml looks like

<catalog>
 <book id="31">
  <author>Boris Vian</author>
  <title>The Big Sleep</title>
 </book>
 <book id="32">
  <author>Boris Vian</author>
  <title>The Lady in the Lake</title>
 </book>
 <book id="33">
  <author>Boris Vian</author>
  <title>The World of Null-A</title>
 </book>
</catalog>

the ExtractValue will extract all the authors and the we've the same author name thrice 
output - Boris Vian Boris Vian Boris Vian
so used SUBSTRING_INDEX function to get the first two words of the author name which basically is the 
first name and last name
*/