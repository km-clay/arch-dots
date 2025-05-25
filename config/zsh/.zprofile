find_laptop() {
	seq 1 254 | xargs -P 254 -I {} bash -c 'curl --max-time 0.5 -s http://192.168.1.{}:8123 -o /dev/null && printf "192.168.1.{}"'
}
