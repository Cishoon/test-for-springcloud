#!/bin/bash

wait_for_startup() {
    LOG_FILE=$1
    APP_NAME=$2
    tail -f $LOG_FILE | while read LOGLINE
    do
        [[ "${LOGLINE}" == *"Started"* ]] && pkill -P $$ tail
    done
}

case "$1" in
    server)
        cd server
        mvn spring-boot:run
        ;;
    provider)
        cd provider
        SERVER_PORT=8081 mvn spring-boot:run
        ;;
    provider2)
        cp -r provider provider2
        cd provider2
        SERVER_PORT=8083 mvn spring-boot:run
        ;;
    consumer)
        cd consumer
        mvn spring-boot:run
        ;;
    config)
        cd config
        mvn spring-boot:run
        ;;
    gateway)
        cd gateway
        mvn spring-boot:run
        ;;
    all)
        echo "Starting server..."
        nohup ./start.sh server > server_output.log &
        wait_for_startup server_output.log "Server"
        echo "Server started."

        echo "Starting config..."
        nohup ./start.sh config > config_output.log &
        wait_for_startup config_output.log "Config"
        echo "Config started."

        echo "Starting provider, provider2, consumer, and gateway concurrently..."
        cp -r provider provider2
        nohup ./start.sh provider > provider_output.log &
        nohup ./start.sh provider2 > provider2_output.log &
        nohup ./start.sh consumer > consumer_output.log &
        nohup ./start.sh gateway > gateway_output.log &
        
        wait_for_startup provider_output.log "Provider"
        wait_for_startup provider2_output.log "Provider2"
        wait_for_startup consumer_output.log "Consumer"
        wait_for_startup gateway_output.log "Gateway"
        
        echo "All services started."
        ;;
    clean)
        echo "Cleaning up..."
        kill -9 $(lsof -t -i:8080)
        kill -9 $(lsof -t -i:8081)
        kill -9 $(lsof -t -i:8082)
        kill -9 $(lsof -t -i:8083)
        kill -9 $(lsof -t -i:8761)
        kill -9 $(lsof -t -i:8888)
        rm -rf provider2
	rm *.log
        echo "Clean up completed."
        ;;
    check)
        lsof -t -i :8080-8083,8761,8888
        ;;
    *)
        echo "Invalid argument. Please provide 'server', 'provider', 'provider2', 'consumer', 'config', 'gateway', 'all', 'clean', or 'check' as an argument."
        exit 1
        ;;
esac
