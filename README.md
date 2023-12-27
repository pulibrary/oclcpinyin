# OCLC Connexion Pinyin Conversion Macro

A macro for OCLC Connexion Client that allows the user to convert a field of Chinese text
to Hanyu Pinyin, with certain catalog-record-specific formatting applied. 

![image](img/example505.jpg)

[Download the macro](https://github.com/pulibrary/oclcpinyin/releases/latest/download/Pinyin.mbk)

[Download the "Extras" macro](https://github.com/pulibrary/oclcpinyin/releases/latest/download/PinyinExtras.mbk)

Please also see the [AddPinyin Plugin for MarcEdit](https://library.princeton.edu/eastasian/addpinyin-plugin-marcedit), which can be used for batch processing of records outside of OCLC Connexion. 

## Demonstration video
[![Demonstration video](https://img.youtube.com/vi/xi1LOWUzqU0/0.jpg)](https://youtu.be/xi1LOWUzqU0)

## Sources
The macro contains a dictionary of Chinese characters and phrases based on three sources:
- The [Unihan database](http://unicode.org/charts/unihan.html), copyright 1991-2020, Unicode, Inc. Last updated 2020-02-18.
- [CC-CEDICT](http://www.mdbg.net/chinese/dictionary?page=cedict), copyright 2020, MDBG. Last updated 2021-04-21.
- User feedback.

## Feedback
To suggest new terms for the dictionary (or to provide general feedback), please go to the "Issues" tab at the top of this github page, and click the "New Issue" button. Alternatively, you can provide feedback using the form below. (Please select the option "Feedback regarding website or software tools".)

https://library.princeton.edu/eastasian/contact 

## Functionality
- This macro converts Chinese characters to pinyin, and the converted text is placed in a separate field which is then linked with the original-language field.
- In general, the macro will convert each Chinese character to pinyin in lowercase letters, with a space between each character.
- Characters that are Romanized differently in different contexts are also handled. For example, the character 会 is written as "kuai" in the phrase 财会 and as "hui" in the phrase 会议.
- The first word of each field or subfield is capitalized, as well as the first word of a phrase in quotation marks.
- Personal names found in the 100, 600, 700 and 800 fields are formatted as follows: Both the first and second characters of the name are capitalized, with a comma in between. If there is a third character in the name, it is written together with the second character as a single word. For example, "温道明" becomes "Wen, Daoming".
- Personal names found in subfield r of any field are formatted in a similar way, but without the comma.
- Some geographic names are written with special formatting. For example, "北京市" is written "Beijing Shi" instead of "bei jing shi".
- Chinese numerals are converted to Arabic numerals if any of the following conditions are met:
  - The number is a 4-digit year (that is, 4 single-digit numbers in a row).
  - The number comes right after the ordinal marker 第.
  - The number appears in field 245 subfield n or field 830 subfield n.
  - The number appears in a date. Recognized date formats include # 年 # 月 # 日, # 年 # 月, and # 月 # 日, as well as date ranges, such as # 年 # 月 # 日 至 # 日 . 
- A sequence of single-digit numbers after 第 or in field 245 subfield n or field 830 subfield n is written as a single number without spaces. 4-digit years are handled in the same way.
- CJK punctuation, such as the full stop(。) or angle bracket (《) are converted to their Latin equivalents.
- In fields 600-651, if the second indicator is "4", it is changed to "0" in the parallel field.
- After conversion, the converted field is checked, and any characters not in the EACC character set are displayed in a dialog box.

**It is still important to proofread the results after conversion!** Small manual adjustments may still be needed. The macro cannot always determine when special formatting is needed. For example:

- Personal names found outside the 100, 600, 700, or 800 fields will not be written with commas or special capitalization, and will not have the given name written as a single word.
- An apostrophe is always placed between the syllables of a personal name if the second syllable begins with a vowel. The apostrophe must be removed manually if it is not desired in cases where there is no ambiguity.
- The macro applies special formatting to many major geographic names, but the list is not comprehensive. Future versions of the macro may include additional names, based on user feedback. Please use our suggestion form to make any suggestions.
- Though the macro is often able to determine the correct pronunciation for a character that has multiple pronunciations, it may not do so in all cases. Please use our suggestion form to let us know about any characters or phrases that are not Romanized correctly.
- The "extra" macros can assist in making manual adjustments to numbers or proper names. Please see the section below for details. 

## Extra Macros for Manual Adjustments

- The Pinyin Conversion Macro may not always format proper names or numbers in the desired way. For this reason, some extra macros have been provided to make it easier to make manual adjustments to the Romanized field. These macros can be found in the macro book PinyinExtras.mbk. These macros are designed to be run after the Pinyin Conversion Macro has created the Romanized field. To use any of these macros, simply highlight some text in the Romanized field and run the macro.
- The **"ProperName"** macro allows you to format text as a proper name (e.g. "ao da li ya" becomes "Aodaliya"). The macro takes the highlighted text, capitalizes the first letter, and removes all spaces between the syllables. Spaces at the beginning or the end of the selection are preserved.
- The **"PersonalName"** macro allows you to format text as a personal name (e.g. "hu jin tao" becaomes "Hu Jintao"). The macro takes the highlighted text, capitalizes the first letters of the first and second syllables, and removes the space between the second and third syllables if there is a third syllable. Any text beyond the third syllable is left unchanged. Any spaces at the beginning or the end of the selection are preserved. The selection must contain at least one other space. No comma is added to the name, since the Pinyin Conversion Macro already does this in the fields in which it is needed.
- The **"ConvertNumbers"** macro converts Arabic numbers to pinyin text and vice versa. When using this macro, note the following:
- The highlighted text must correspond to Chinese characters in the original language field. If the original language field contains Arabic numerals and these are simply copied over to the Romanized field, these numbers cannot be converted.
  - The Chinese field must appear right above the Romanized field and have the same tag name and the same set of subfields.
  - The highlighted text must contain Arabic numerals only or pinyin text only, not a combination of the two. Punctuation should not be included in the selection.
  - The macro cannot be used to convert part of a number. For example, if "215" appears in the Romanized field, attempting to convert only the "15" produces an error message.

## Installation Instructions

1. Close OCLC Connexion Client if it is open.
2. Download the file [Pinyin.mbk](https://github.com/pulibrary/oclcpinyin/releases/latest/download/Pinyin.mbk). Save it in your OCLC Macro directory, which is usually "C:\Program Files\OCLC\Connexion\Program\Macros". If you have already installed a previous version of the file, simply replace it with the new one.
3. Open OCLC Connexion Client. Open the "Tools" menu and select "Macros > Manage...". In the list of macro books, there should be one called "Pinyin" containing a macro "Hanzi2Pinyin". After confirming this, click "OK".
4. To add the macro to the toolbar:
  - Select "Tools > User Tools > Assign...". At the top of the screen, click "Macros". In the list box on the left side of the window, select "Pinyin!Hanzi2Pinyin".
  - Under the "Select New User Tool" menu, select a tool that is not yet assigned to another function. Make note of the tool number, then click "Assign Tool", and then "OK".
  - Select "Tools > Toolbar Editor...". Scroll down to "ToolsUserToolsX", where X is the tool number that you just assigned to the macro. Drag the icon to the desired location on the toolbar.
5. To assign a keyboard shortcut:
  - Select "Tools > Keymaps...". In the "Select Commands for Category" box at the top of the window, select "Macros". Double-click "Pinyin", then click "Hanzi2Pinyin".
  - Click in "Press New Shortcut Key" and press the keyboard shortcut you would like to assign to this macro (Alt+R is a good choice, as it does not seem to conflict with any other shortcuts).
  - Make sure that "Shortcut Key Assigned to:" is blank, then click "Assign" and then "OK". 
6. To run the macro, click in the field you would like to convert, then activate the macro, using either the keyboard shortcut or toolbar button.
7. To install the extra macros, repeat the steps above with the file PinyinExtras.mbk . This will create a macro book called "PinyinExtras" containing the macros "ProperName", "PersonalName", and "ConvertNumbers". A different toolbar button and/or keyboard shortcut should be created for each of these macros. (Alt+P, Alt+S, and Alt+N, respectively, may be good choices).
8. **Note to users of OCLC Connexion 3.1**: The macro may initially produce an error message after upgrading to version 3.1. If this happens, go to "Tools > Macros > Convert to Version 3 Macro Format...". Then click the "Select MacroBook..." button, select "Pinyin.mbk", and click "Open". Finally, click the "Convert" button. This should resolve the issue.

## Source Code
The source code for the macros is provided in the "src" directory.  Note that the code for the main macro **"Pinyin.Hanzi2Pinyin"** is generated dynamically directly from the dictionary files.  The code for generating this macro is provided as well.  The README file in the src directory describes this process in more detail.

