from confluent_kafka import Producer

p = Producer({'bootstrap.servers': '192.168.1.61:9092'})
kdata = "Saluto"
data = "Ciao da Python"

def delivery_report(err, msg):
    """ Called once for each message produced to indicate delivery result.
        Triggered by poll() or flush(). """
    if err is not None:
        print('Message delivery failed: {}'.format(err))
    else:
        print('Message delivered to {} [{}] {}'.format(msg.topic(), msg.partition(), msg.offset()))

# Trigger any available delivery report callbacks from previous produce() calls
p.poll(0)

# Asynchronously produce a message, the delivery report callback
# will be triggered from poll() above, or flush() below, when the message has
# been successfully delivered or failed permanently.
p.produce(topic='Fabrizio', key=kdata.encode('utf-8'), value=data.encode('utf-8'), callback=delivery_report)

# Wait for any outstanding messages to be delivered and delivery report
# callbacks to be triggered.
p.flush()