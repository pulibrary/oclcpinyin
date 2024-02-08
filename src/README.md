# OCLC Connexion Pinyin Converter Macro - Source files

OCLC Connexion Macros have the ability to access external files, but doing so slows down the macro 
considerably, especially for large files.  To get around this, the macro essentially encloses
the entire dictionary inside a large SWITCH statement.  Therefore, the source code of the macro
must be generated automatically, using text files as a starting point.  The Perl scripts and files
in this directory are designed to generate this code.  The code can then be copied and pasted
into the OCLC Macro editor and saved.  This is how the macro is finally "compiled".

Basically, the Unihan list is used as the source of single-character entries, and CC-CEDICT as the source of multi-character entries.  (Though entries from either list can be overridden by one of the manual dictionary files).  To keep the dictionary has small as possible, the scripts only includes a multi-character entry if the romanization is different than what you would get considering the characters individually (i.e. at least one character has a variant reading, or special spacing/capitlization needs to be used).

The macro is written in OCLC Macro Language (OML), which is an extension of Softbridge Visual Basic 3.0.  

## Source code files
- ConvertNumbers.txt: Source code for the "PinyinExtras.ConvertNumbers" macro.
- PersonalName.txt: Source code for the "PinyinExtras.PersonalName" macro.
- ProperName.txt: Source code for the "PinyinExtras.ProperName" macro.
- vbdictTemp.txt: A template for the "Pinyin.Hanzi2Pinyin" macro, with auto-generated sections indicated with bracketed phrases.
- vbdict.txt: The final source code of the "Pinyin.Hanzi2Pinyin" macro.

## External dictionary files (must be downloaded by user):
- cedict_ts.u8.txt:  The CC-CEDICT source dictionary (http://www.mdbg.net/chindict/chindict.php?page=cedict).
- Unihan_Readings.txt: The Unihan readings list (https://www.unicode.org/Public/UCD/latest/ucd/Unihan.zip)

## Local dictionary files (maintained manually based on user feedback):
- additions.txt: List of multi-character terms manually added to the dictionary (besides geographic names and surnames)
- names.txt: A file of Chinese surnames with more than one character.
- places.txt: A file of geographic names that require special formatting or capitalization.
- pyadditions.txt: List of single-character terms manually added or revised in the dictionary (overrides the Unihan readings list if needed).

## Scripts for generating source code
- formatCEdict.pl: Converts the cedict_ts.u8.txt to a simple tab-delimited format (outputs dict1.txt)
- makePinyinDict.pl: Takes dict1.txt and Unihan_Readings.txt and generates a dictionary of single-character entries, sorted by Unicode codepoint (outputs pinyin.txt)
- condenseDict.pl: Combines dict1.txt and pinyin.txt and makes sure there is only one entry per character,  and that the only multi-character entries are those that contain variant pronunciations of characters (outputs dict2.txt).
- vbdict.pl: Takes dict3.txt (which is compiled from dict2.txt and the other local dictionary files) and generates a dictionary in VB code, filling in the bracked sections in vbdictTemp.txt and generating the source code in vbdict.txt.
- VBSCRIPT.sh: Wrapper script for all steps of the code generation process.  This is the only script that needs to be run directly.


