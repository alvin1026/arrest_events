import os


def get_postgres_uri():
    host = os.environ.get("DB_HOST", "localhost")
    port = 5520 if host == "localhost" else 5432
    password = os.environ.get("DB_PASSWORD", "admin")
    user, db_name = "postgres", "postgres"
    return f"postgresql://{user}:{password}@{host}:{port}/{db_name}"


def get_kafka_consumer_conf():
    bootstrap_servers = os.environ.get("BOOTSTRAP_SERVERS", "localhost:29092")
    group_id = os.environ.get("KAFKA_GROUP_ID", "arrest_group")
    return {
        "bootstrap.servers": bootstrap_servers,
        "group.id": group_id,
        "auto.offset.reset": "smallest",
    }


def get_kafka_producer_conf():
    bootstrap_servers = os.environ.get("BOOTSTRAP_SERVERS", "localhost:29092")
    return {
        "bootstrap.servers": bootstrap_servers,
    }
