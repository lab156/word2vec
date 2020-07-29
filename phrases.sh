make
#TEXTF=news.2012.en.shuffled
TEXTF=math19
#if [ ! -e news.2012.en.shuffled ]; then
#  wget http://www.statmt.org/wmt14/training-monolingual-news-crawl/news.2012.en.shuffled.gz
#  gzip -d news.2012.en.shuffled.gz -f
#fi
sed -e "s/’/'/g" -e "s/′/'/g" -e "s/''/ /g" < $TEXTF | tr -c "A-Za-z'_ \n" " " > $TEXTF-norm0
time ./word2phrase -train $TEXTF-norm0 -output $TEXTF-norm0-phrase0 -threshold 200 -debug 2
time ./word2phrase -train $TEXTF-norm0-phrase0 -output $TEXTF-norm0-phrase1 -threshold 100 -debug 2
tr A-Z a-z < $TEXTF-norm0-phrase1 > $TEXTF-norm1-phrase1
time ./word2vec -train $TEXTF-norm1-phrase1 \
  -output $TEXTF-vectors-phrase.bin \
  -cbow 1 -size 200 -window 10 \
  -negative 25 -hs 0 -sample 1e-5 \
  -threads 30 -binary 1 -iter 15
./distance $TEXTF-vectors-phrase.bin

