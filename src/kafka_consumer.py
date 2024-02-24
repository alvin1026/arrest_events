import json
import logging

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from confluent_kafka import Consumer, KafkaError

from domain.model import ArrestEvent
from config import get_kafka_consumer_conf, get_postgres_uri

TOPIC = "arrest_event"

logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)


def create_session_factory():
    connection_string = get_postgres_uri()
    engine = create_engine(connection_string)
    session = sessionmaker(bind=engine)
    return session


Session = create_session_factory()


def process_message(msg):
    try:
        event_data = json.loads(msg.value().decode("utf-8"))
        logger.info("Receive: {event_data}")
        arrest_event = ArrestEvent(
            officer_id=event_data.get("officer_id"),
            subject_id=event_data.get("subject_id"),
            arrest_type_id=event_data.get("arrest_type_id"),
            arrested_at=event_data.get("arrested_at"),
            crime_type_id=event_data.get("crime_type_id"),
        )
        session = Session()
        session.add(arrest_event)
        session.commit()
        session.close()
    except Exception as e:
        logger.error(f"Error processing message: {str(e)}")


def stream_processing():
    consumer = Consumer(get_kafka_consumer_conf())
    consumer.subscribe([TOPIC])
    try:
        while True:
            msg = consumer.poll(timeout=1.0)
            if msg is None:
                continue
            if msg.error():
                if msg.error().code() == KafkaError._PARTITION_EOF:
                    continue
                else:
                    print(msg.error())
                    break
            process_message(msg)
    finally:
        consumer.close()


if __name__ == "__main__":
    stream_processing()
