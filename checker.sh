#!/bin/bash

load_config(){

	# Telegram
	TELEGRAM_TOKEN=""
	TELEGRAM_CHAT=""
	TELEGRAM_ENDPOINT="https://api.telegram.org/bot"$TELEGRAM_TOKEN"/sendMessage?chat_id="$TELEGRAM_CHAT

	# Memory
	MEMORY_CRITICAL=90
	MEMORY_WARNING=80	

	# Disk
	DISK_CRITICAL=90
	DISK_WARNING=80

 	# CPU
	CPU_CRITICAL=90
	CPU_WARNING=80	

	# Ping
	PING_HOST="google.es"
}

check_mem(){

	totalRam=$(free -m | awk '/Mem:/ { print $2 }')
	freeRam=$(free -m | awk '/Mem:/ { print $4 }')
	totalSwap=$(free -m | awk '/Swap:/ { print $2 }')
	freeSwap=$(free -m | awk '/Swap:/ { print $3 }')

}

check_disk(){

	totalDisk=$()
	freeDisk=$()

}

check_cpu(){
	totalCPU=$()
	freeCPU=$()
}

check_ping(){

	ping=$(ping -q -c3 $PING_HOST > /dev/null)

	if [ "$ping" != 0 ]
	then
		send_error "CRITICAL" "Ping to $PING_HOST has failed." 

	fi
}

send_error(){

	message="$1 - $2"
	$(curl -s -X POST $TELEGRAM_ENDPOINT -F text="$message" > /dev/null)

}

check() {

	load_config
	check_mem
	check_disk
	check_cpu
	check_ping

}

check
