OCLC Connexion Pinyin Converter Macro

DESCRIPTION
A plugin for OCLC Connexion Client that allows the user to convert a field of Chinese text
to Hanyu Pinyin, with certain catalog-record-specific formatting applied.  

OCLC Macros have the ability to access external files, but doing so slows down the macro 
considerably, especially for large files.  To get around this, the macro essentially encloses
the entire dictionary inside a large SWITCH statement.  Therefore, the source code of the macro
must be generated automatically, using a text file as a starting point.  The scripts and files
in this collection are designed to generate this code.  The code can then be copied and pasted
into the OCLC Macro editor and saved.  This is how the macro is finally installed.

FILES
cedict_ts.u8.txt:  The CC-CEDICT source dictionary, which originally was downloaded from 
http://www.mdbg.net/chindict/chindict.php?page=cedict .
dict1.txt: The dictionary output by formatCEdict.pl .
dict2.txt: The dictionary output by condenseDuct.pl .
dict3.txt: dict2.txt, combined with the names, places, and additions file.
names.txt: A file of Chinese surnames with more than one character.
places.txt: A file of geographic names that require special formatting or capitalization.
additions.txt: Additional words and characters to be added to the dictionary.
pinyin.txt: A dictionary mapping Unicode codepoints of chracters to pinyin.
vbdictTemp.txt: A template for the source code, with auto-generated sections
indicated with bracketed phrases.
vbdict.txt: The final source code of the macro.

SCRIPTS
formatCEdict.pl: Converts the CEDICT to a simple tab-delimited format (dict1.txt)
condenseDict.pl: Takes dict1.txt and makes sure there is only one entry per character, 
and that the only multi-character entries are those that contain variant pronunciations 
of characters (dict1.txt).
makePinyinDict.pl: Takes dict1.txt and generates a dictionary of one-character entries,
sorted by Unicode codepoint.
VBDICT.SH: Wrapper script for all steps of the code generation process.
vbdict.pl: takes dict3.txt and generates a dictionary, filling in the blanks in vbdictTemp.txt
and generating the source code in vbdict.txt.


