from confluent_kafka.admin import AdminClient

c = AdminClient({
    'bootstrap.servers': '192.168.1.61:9092',
})

info = c.list_topics("Fabrizio").topics

print(f"{info['Fabrizio']}")

# To get exactly number, I need to change the __str__ method on TopicMedadata Class
#def __str__(self):
#        return str(len(self.partitions))
