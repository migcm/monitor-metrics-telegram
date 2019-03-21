#!/bin/bash

load_config(){

	# Telegram
	TELEGRAM_TOKEN=""
	TELEGRAM_CHAT=""
	TELEGRAM_ENDPOINT="https://api.telegram.org/bot"$TELEGRAM_TOKEN"/sendMessage?chat_id="$TELEGRAM_CHAT

	# Ram
	RAM_CRITICAL=90
	RAM_WARNING=80	

	# Swap
	SWAP_CRITICAL=90
	SWAP_WARNING=80

	# Disk
	DISK_CRITICAL=90
	DISK_WARNING=80

 	# CPU
	CPU_CRITICAL=90
	CPU_WARNING=80	

	# Ping
	PING_HOST="google.es"
}

check_ram(){

	totalRam=$(free -m | awk '/Mem:/ { print $2 }')
	freeRam=$(free -m | awk '/Mem:/ { print $4 }')

	percentRam$(bc <<< "scale=1; $freeRam*100 / $totalRam")
}

check_swap(){

        totalSwap=$(free -m | awk '/Swap:/ { print $2 }')
        freeSwap=$(free -m | awk '/Swap:/ { print $3 }')

        percentSwap$(bc <<< "scale=1; $freeSwap*100 / $totalSwap")

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
	check_ram
	check_swap
	check_disk
	check_cpu
	check_ping

}

check
