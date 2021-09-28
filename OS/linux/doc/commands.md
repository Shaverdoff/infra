# replace old_word in all files to new_word
```
find . -name '*.yaml' | xargs perl -pi -e 's/old_word/new_word/g;'
```
