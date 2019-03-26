# Monitor metrics and send notifications to telegram

This allows you to monitor remote machine metrics (disk usage, CPU load, etc.) and send notifications to telegram if certain thresholds are exceeded.

It is necessary to create a cron that executes the script every "x" seconds/minutes/hours/days...

The script works similar to [Nagios](https://www.nagios.org/) [NRPE](https://support.nagios.com/kb/category.php?id=10) but without using another external server. It is a low cost monitoring.


### Configuration
Edit the checker.sh file and modify the configuration variables with the parameters you want.

* **TELEGRAM_TOKEN**: It is necessary to create a new Telegram bot using [Bot Father](https://core.telegram.org/bots#6-botfather).
* **TELEGRAM_CHAT**: It is necessary to create a channel/chat of Telegram and [take the ID of it](https://github.com/GabrielRF/telegram-id#web-channel-id). It is also necessary to put the bot as administrator of the channel/chat.
* **DEBUG_MODE**: If you want debug mode, put a 1, if not a 0.
* **RAM_CRITICAL**: Percentage of busy RAM that will be notified that the server is in a critical state.
* **RAM_WARNING**: Percentage of busy RAM that will be notified that the server is in a warning state.
* **SWAP_CRITICAL**: Percentage of busy swap that will be notified that the server is in a critical state.
* **SWAP_WARNING**: Percentage of busy swap that will be notified that the server is in a warning state.
* **DISK_CRITICAL**: Percentage of busy disk that will be notified that the server is in a critical state.
* **DISK_WARNING**: Percentage of busy disk that will be notified that the server is in a warning state.
* **CPU_CRITICAL**: Percentage of busy CPU that will be notified that the server is in a critical state.
* **CPU_WARNING**: Percentage of busy CPU that will be notified that the server is in a warning state.
* **PING_HOSTS**: Host to which the ping will be made. They should be separated by ";".
* **PING_NUMBER**: Number of pings to be made in the check.
* **PROCESSES_LIST**: Processes that will be verified that they are running. They should be separated by ";".
* **PORTS_LIST**: Ports to be checked that are open. It should be written as host:port (For example: localhost:80). They should be separated by ";".


### Checks available
* check_ram    
* check_swap
* check_disk
* check_cpu
* check_ping
* check_processes
* check_iptables
* check_ports


### Contribution
Feel free to contribute!

