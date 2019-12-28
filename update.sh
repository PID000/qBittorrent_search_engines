#!/bin/bash
# A simple script to update the plugins of Qbittorent

url='https://github.com/qbittorrent/search-plugins.wiki.git'
tmp_dir=$(mktemp -d)
public_tmp=$(mktemp)
private_tmp=$(mktemp)

# backup old scripts
rm -rf bak 1>/dev/null 2>&1
mkdir -p bak
mv public* bak 1>/dev/null 2>&1
mv private* bak 1>/dev/null 2>&1
mv Plugin* bak 1>/dev/null 2>&1

git clone $url $tmp_dir

split_line=$(grep -n "Private" $tmp_dir/Unofficial-search-plugins.mediawiki | awk -F: '{print $1}')
sed -n "1,$split_line p" $tmp_dir/Unofficial-search-plugins.mediawiki > $public_tmp
sed -n "$split_line,\$ p" $tmp_dir/Unofficial-search-plugins.mediawiki > $private_tmp

echo ""
echo ":: Public site lists"
echo ""
grep -o -e "http.*\.py" $public_tmp > public_list
cat public_list

echo ""
echo ":: private site lists"
echo ""
grep -o -e "http.*\.py" $private_tmp > private_list
cat private_list

mkdir -p Plugins_for_Public_sites
mkdir -p Plugins_for_Private_sites

echo ""
echo ":: Download Plugins for Public sites"
echo ""

cd Plugins_for_Public_sites
#COUNTER=1

for file in $(cat ../public_list)
do
    wget $file #-O "$COUNTER""_""$(echo $file|awk -F\/ '{print $NF}')"
    #((COUNTER=COUNTER+1))
done

echo ""
echo ":: Download Plugins for Private sites"
echo ""

cd ../Plugins_for_Private_sites
#COUNTER=1
for file in $(cat ../private_list)
do
    wget $file #-O "$COUNTER""_""$(echo $file|awk -F\/ '{print $NF}')"
    #((COUNTER=COUNTER+1))
done

rm -rf $tmp_dir $private_tmp $public_tmp