#!/bin/bash -x

./formatCEdict.pl cedict_ts.u8.txt > dict1.txt
cat pyadditions.txt > pinyin.txt
./makePinyinDict.pl >> pinyin.txt
./condenseDict.pl dict1.txt > dict2.txt
cat dict2.txt additions.txt places.txt names.txt | sed -e "s/\xEF\xBB\xBF//g" > dict3.txt
./vbdict.pl dict3.txt > vbdict.txt
