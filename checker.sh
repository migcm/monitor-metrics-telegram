#!/bin/bash

load_config(){

	# Telegram
	TELEGRAM_TOKEN=""
	TELEGRAM_CHAT=""
	TELEGRAM_ENDPOINT="https://api.telegram.org/bot"$TELEGRAM_TOKEN"/sendMessage?chat_id="$TELEGRAM_CHAT

	# Other
        DEBUG_MODE=1

	#Check
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
		PING_HOSTS="google.es;192.168.1.1"
		PING_NUMBER=3
		#Processes
		PROCESSES_LIST="ssh;http"
		# Iptables
		# Ports
		PORTS_LIST="localhost:80;localhost:443"
}

check_ram(){

	totalRam=$(free -m | awk '/Mem:/ { print $2 }')
	freeRam=$(free -m | awk '/Mem:/ { print $4 }')

	percentRam=$(bc <<< "scale=1; $freeRam*100 / $totalRam")

	if [ "$percentRam" > $RAM_CRITICAL ]
        then
                send_error "CRITICAL" "The ram is at $percentSwap."
        elif [ "$percentRam" > $RAM_WARNING  ]
        then
                send_error "WARNING" "The ram is at $percentSwap."
        fi


	# Debug mode
	if [ $DEBUG_MODE == 1 ]
	then
                send_error "DEBUG" "The ram has been checked: $percentRam %."
                echo "DEBUG - The ram has been checked: $percentRam %."
	fi
}

check_swap(){

    totalSwap=$(free -m | awk '/Swap:/ { print $2 }')
    freeSwap=$(free -m | awk '/Swap:/ { print $3 }')

    percentSwap=$(bc <<< "scale=1; $freeSwap*100 / $totalSwap")

	if [ "$percentSwap" > $SWAP_CRITICAL ]
        then
                send_error "CRITICAL" "The swap is at $percentSwap."
        elif [ "$percentSwap" > $SWAP_WARNING  ]
	then
                send_error "WARNING" "The swap is at $percentSwap."
	fi


	# Debug mode
	if [ $DEBUG_MODE == 1 ]
        then
                send_error "DEBUG" "The swap has been checked: $percentSwap %."
                echo "DEBUG - The swap has been checked: $percentSwap %."
        fi
}


check_disk(){

	totalDisk=$(df -h --output=size -x tmpfs -x devtmpfs)
	freeDisk=$(df -h --output=avail -x tmpfs -x devtmpfs)
	percentDisk=$(df -h --output=pcent -x tmpfs -x devtmpfs)


	if [ "$percentDisk" > $DISK_CRITICAL ]
        then
                send_error "CRITICAL" "HD is at $percentDisk."
        elif [ "$percentDisk" > $DISK_WARNINGS  ]
	then
                send_error "WARNING" "HD is at $percentDisk."
	fi


	# Debug mode
	if [ $DEBUG_MODE == 1 ]
        then
                send_error "DEBUG" "The disk has been checked: $percentDisk %."
                echo "DEBUG - The disk has been checked: $percentDisk %."
        fi

}

check_cpu(){

	totalCPU=$(top -bn1 | grep "Cpu(s)" | \
           sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | \
           awk '{print 100 - $1"%"}')

	freeCPU=$(top -bn1 | grep "Cpu(s)" | \
           sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | \
           awk '{print $1"%"}')

    if [ "$freeCPU" > $CPU_CRITICAL ]
        then
                send_error "CRITICAL" "CPU is at $freeCPU."
        elif [ "$freeCPU" > $CPU_WARNING  ]
	then
                send_error "WARNING" "CPU is at $freeCPU."
	fi


	# Debug mode
        if [ $DEBUG_MODE == 1 ]
        then
                send_error "DEBUG" "The CPU has been checked: $percentCPU %."
                echo "DEBUG - The CPU has been checked: $percentCPU %."
        fi
}

check_ping(){

	hosts=$(echo $PING_HOSTS | tr ";" "\n")

        for host in $hosts
        do

		ping=$(ping -i 0.2 -c $PING_NUMBER $host > /dev/null)

		if [ "$ping" != 0 ]
		then
			send_error "CRITICAL" "Ping to $host has failed." 
		fi


		# Debug mode
		if [ $DEBUG_MODE == 1 ]
        	then
                	send_error "DEBUG" "The ping to $host has been checked."
                	echo "DEBUG - The ping to $host has been checked."
        	fi
	done
}

check_processes(){

	processes=$(echo $PROCESSES_LIST | tr ";" "\n")

	for proc in $processes
	do

		running=$(ps ax | grep -v grep | grep $proc | wc -l)
		if [ $running -le 0 ]
		then
			send_error "CRITICAL" "The $proc process is not running."
		fi

		if [ $DEBUG_MODE == 1 ]
		then
			send_error "DEBUG" "The $proc process has been checked."
			echo "DEBUG - The $proc process has been checked."
		fi
	done
}

check_iptables(){

	iptablesUP=$(sudo iptables -n -L -v --line-numbers | egrep "^[0-9]" | wc -l)
	if [ $iptablesUP -le 0 ]
        then
        	send_error "CRITICAL" "Iptables rules are disabled."
        fi

        if [ $DEBUG_MODE == 1 ]
        then
        	send_error "DEBUG" "It has been checked if the iptables are disabled."
                echo "DEBUG - It has been checked if the iptables are disabled."
        fi

}

check_ports(){

	ports=$(echo $PORTS_LIST | tr ";" "\n")

	for port in $ports
	do

		hostP=$(echo $port | tr ":" " ")

		portTest=$(nc -zv $hostP 2>&1)

		if [[ $portTest != *"succeeded"* ]]; then
  			send_error "CRITICAL" "The port [$port] is not open."
		fi

		if [ $DEBUG_MODE == 1 ]
		then
			send_error "DEBUG" "The port [$port] has been checked."
			echo "DEBUG - The port [$port] has been checked."
		fi
	done
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
	check_processes
	check_iptables
	check_ports

}

check
