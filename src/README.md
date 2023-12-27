# OCLC Connexion Pinyin Converter Macro - Source files

OCLC Connexion Macros have the ability to access external files, but doing so slows down the macro 
considerably, especially for large files.  To get around this, the macro essentially encloses
the entire dictionary inside a large SWITCH statement.  Therefore, the source code of the macro
must be generated automatically, using a text files as a starting point.  The scripts and files
in this collection are designed to generate this code.  The code can then be copied and pasted
into the OCLC Macro editor and saved.  This is how the macro is finally "compiled".

## Source code files
- ConvertNumbers.txt: Source code for the "PinyinExtras.ConvertNumbers" macro.
- PersonalName.txt: Source code for the "PinyinExtras.PersonalName" macro.
- ProperName.txt: Source code for the "PinyinExtras.ProperName" macro.
- vbdictTemp.txt: A template for the "Pinyin.Hanzi2Pinyin" macro, with auto-generated sections indicated with bracketed phrases.
- vbdict.txt: The final source code of the "Pinyin.Hanzi2Pinyin" macro.

## External dictionary files (must be downloaded by user):
- cedict_ts.u8.txt:  The CC-CEDICT source dictionary (http://www.mdbg.net/chindict/chindict.php?page=cedict).
- Unihan_Readings.txt: The Unihan readings list (https://www.unicode.org/Public/UCD/latest/ucd/Unihan.zip)

## Local dictionary files
- additions.txt: List of multi-character terms manually added to the dictionary (besides geographic names and surnames)
- names.txt: A file of Chinese surnames with more than one character.
- places.txt: A file of geographic names that require special formatting or capitalization.
- pinyin.txt: List of single-character terms manually added or revised in the dictionary.

## Scripts for generating source code
- condenseDict.pl: Takes dict1.txt and makes sure there is only one entry per character,  and that the only multi-character entries are those that contain variant pronunciations of characters (dict1.txt).
- formatCEdict.pl: Converts the CEDICT to a simple tab-delimited format (dict1.txt)
- makePinyinDict.pl: Takes dict1.txt and generates a dictionary of one-character entries, sorted by Unicode codepoint.
- VBSCRIPT.sh: Wrapper script for all steps of the code generation process.
- vbdict.pl: takes dict3.txt and generates a dictionary, filling in the blanks in vbdictTemp.txt
and generating the source code in vbdict.txt.


