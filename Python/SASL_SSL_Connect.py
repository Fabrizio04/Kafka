from types import NoneType
from confluent_kafka import Consumer


c = Consumer({
    'bootstrap.servers': '192.168.1.61:9092',
    'group.id': 'Fabry',
    'auto.offset.reset': 'earliest',
	
	'security.protocol' : 'SASL_SSL',
	'sasl.mechanisms' : 'PLAIN',
	'sasl.username' : 'admin',
	'sasl.password' : 'admin-secret',
	
	'ssl.endpoint.identification.algorithm' : 'none',
	'ssl.ca.location' : 'C:\\Users\\Fabrizio\\Desktop\\root.pem',
	'ssl.certificate.location' : 'C:\\Users\\Fabrizio\\Desktop\\consumer_client.pem',
	'ssl.key.location' : 'C:\\Users\\Fabrizio\\Desktop\\key.pem'
})

c.subscribe(['Fabrizio'])

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
