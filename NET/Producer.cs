using Confluent.Kafka;
using System.Net;

string topic = "Fabrizio";
string keyValue = "Saluto";
string mesValue = "Ciao";

var config = new ProducerConfig
{
    BootstrapServers = $"192.168.1.61:9092",
    ClientId = Dns.GetHostName(),
};

Console.WriteLine($"Send message: [{keyValue} : {mesValue}]");

using (var producer = new ProducerBuilder<string, string>(config).Build())
{
    var t = producer.ProduceAsync(topic, new Message<string, string> { 
        Key = keyValue,
        Value = mesValue
    });

    producer.Flush();

    t.ContinueWith(task =>
    {
        if (task.IsFaulted)
        {
            Console.WriteLine("ERRORE: message not send");
        }
        else
        {
            Console.WriteLine($"Inserted to offset: {task.Result.Offset}");
        }
    });
}
