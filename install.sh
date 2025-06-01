if [[ ! -e ./config || ! -d .config ]]; then
	echo "./config does not exist, or is not a directory. exiting"
	exit 1
fi

echo "This script will move the following directories to ./backup:"
for file in ./config/*; do
	echo "~/.config/$(basename $file)"
done
echo
echo "continue?"
