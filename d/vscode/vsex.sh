#! /bin/bash
cat ./extension-list.txt | while read i
do
  code --install-extension $i
done

