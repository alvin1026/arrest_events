import json

from confluent_kafka import Consumer, KafkaError, Producer

from config import get_kafka_producer_conf

TOPIC = "arrest_event"


producer = Producer(get_kafka_producer_conf())


# Sample data to be produced
arrest_event = {
    "officer_id": 1,
    "subject_id": 4,
    "arrest_type_id": 2,
    "arrested_at": "2024-01-28 09:00:00",
    "crime_type_id": 2,
}
msg = json.dumps(arrest_event).encode("utf-8")

producer.produce(TOPIC, value=msg)

producer.flush()
