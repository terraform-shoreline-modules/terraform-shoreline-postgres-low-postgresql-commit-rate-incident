
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Low Postgresql commit rate incident
---

The Low Postgresql commit rate incident is triggered when the number of transactions processed by Postgresql drops below a certain threshold, indicating a potential issue with the database's performance. This could be caused by a variety of factors, such as high load or inadequate resources. The incident requires investigation and resolution to ensure the database is functioning properly.

### Parameters
```shell
# Environment Variables

export DISK="PLACEHOLDER"

export DATABASE_PASSWORD="PLACEHOLDER"

export DATABASE_PORT="PLACEHOLDER"

export DATABASE_USER="PLACEHOLDER"

export DATABASE_NAME="PLACEHOLDER"

export DATABASE_HOST="PLACEHOLDER"
```

## Debug

### Check if Postgresql service is running
```shell
systemctl status postgresql.service
```

### Check Postgresql logs for any errors
```shell
tail -n 50 /var/log/postgresql/postgresql-main.log
```

### Check the current connection count in Postgresql
```shell
sudo -u postgres psql -c "SELECT count(*) FROM pg_stat_activity;"
```

### Check the number of active transactions in Postgresql
```shell
sudo -u postgres psql -c "SELECT SUM(pg_stat_activity.xact_commit) FROM pg_stat_activity;"
```

### Check the Postgresql configuration for any anomalies
```shell
cat /etc/postgresql/main/postgresql.conf
```

### Check the system load and resource utilization
```shell
top
```

### Check disk usage and I/O performance
```shell
df -h

iostat -dx ${DISK}
```

### Check network connectivity to the Postgresql server
```shell
ping ${DATABASE_HOST}
```

### Check firewall rules for the Postgresql port
```shell
iptables -L -n | grep ${DATABASE_PORT}
```

### Check for any other running processes that may be causing contention
```shell
ps -ef | grep postgresql
```

### Check for any Postgresql updates
```shell
sudo -u postgres psql -c "SELECT version();"
```

## Repair

### Check if there are any long-running queries that may be causing a bottleneck. Identify the queries and tune them or optimize the database schema.
```shell


#!/bin/bash



# Set the database credentials

DB_HOST=${DATABASE_HOST}

DB_PORT=${DATABASE_PORT}

DB_NAME=${DATABASE_NAME}

DB_USER=${DATABASE_USER}

DB_PASSWORD=${DATABASE_PASSWORD}



# Connect to the database and check for long-running queries

LONG_RUNNING_QUERIES=$(psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "SELECT query FROM pg_stat_activity WHERE state = 'active' AND now() - query_start > interval '5 minutes';")



# Check if there are any long-running queries

if [ -z "$LONG_RUNNING_QUERIES" ]; then

  echo "No long-running queries found"

else

  echo "Long-running queries found:"

  echo "$LONG_RUNNING_QUERIES"

  
fi


```

### Check if there are any configuration issues with the Postgresql server. Verify the configuration settings and make any necessary changes.
```shell


#!/bin/bash

PATH_TO_PG_CONFIG_FILE=/etc/postgresql/main/postgresql.conf

# Check if Postgresql is installed and running

if ! pgrep -x "postgres" > /dev/null

then

    echo "Postgresql is not running"

    exit 1

fi



# Check the configuration settings for Postgresql

if [ -f ${PATH_TO_PG_CONFIG_FILE} ]

then

    # Make a backup of the configuration file

    cp ${PATH_TO_PG_CONFIG_FILE} ${PATH_TO_PG_CONFIG_FILE}.bak

    

    # Check for any configuration issues and make changes if needed

    # Example: increase the cache size to improve performance

    sed -i 's/shared_buffers = 128MB/shared_buffers = 256MB/' ${PATH_TO_PG_CONFIG_FILE}

    

    # Restart Postgresql to apply the changes

    systemctl restart postgresql

else

    echo "Postgresql configuration file not found"

    exit 1

fi



echo "Postgresql configuration issues remediated successfully"

exit 0


```