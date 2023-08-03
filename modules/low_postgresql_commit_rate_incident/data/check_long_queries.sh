

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