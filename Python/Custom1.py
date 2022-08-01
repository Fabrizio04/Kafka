from types import NoneType
import confluent_kafka
from confluent_kafka import Consumer


c = Consumer({
    'bootstrap.servers': '192.168.1.61:9092',
    'group.id': 'Fabry',
    'auto.offset.reset': 'earliest'
})

def my_assign (consumer, partitions):
        for p in partitions:
            p.offset = confluent_kafka.OFFSET_END
        print('assign', partitions)
        consumer.assign(partitions)


# Read only new messages, ignore all exists on topic
c.subscribe(['Fabrizio'], on_assign=my_assign)

# Automatic subscription for single topic to one partition
#c.assign([confluent_kafka.TopicPartition("Fabrizio", 0)])

# Automatic subscription for single topic to one partition, start consume from specificated offset (included)
#c.assign([confluent_kafka.TopicPartition("Fabrizio", 0, 10)]) 

while True:
    msg = c.poll(1.0)

    if msg is None:
        continue
    if msg.error():
        print("Consumer error: {}".format(msg.error()))
        continue
    
    if isinstance(msg.key(), NoneType):
        key="NO_KEY"
    else:
        key=msg.key().decode('utf-8')

    #key=str(msg.key())
    value=msg.value().decode('utf-8')

    print(f"Received message {key}:{value} [{msg.partition()}][{msg.offset()}]")

c.close()