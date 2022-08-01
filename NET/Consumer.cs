using Confluent.Kafka;

var config = new ConsumerConfig
{
    BootstrapServers = "192.168.1.61:9092",
    GroupId = "fabry",
    AutoOffsetReset = AutoOffsetReset.Earliest,
};

using (var c = new ConsumerBuilder<string, string>(config).Build())
{

    List<string> myTopics = new List<string>() { "Fabrizio", "test" };

    // Automatic subscription for all topic specificated
    // All message will be consumed automatically from all partition if the GroupId not consumed the messages yet
    c.Subscribe(myTopics);

    // Automatic subscription for single topic
    //c.Subscribe("Fabrizio");
    
    // Automatic subscription for single topic to one partition
    //c.Assign(new TopicPartition("Fabrizio",0));
    
    // Automatic subscription for single topic to one partition, start consume from specificated offset (included)
    //c.Assign(new TopicPartitionOffset("Fabrizio",0,5));

    CancellationTokenSource cts = new CancellationTokenSource();

    Console.CancelKeyPress += (_, e) =>
    {
        e.Cancel = true; // Prevent process close
        cts.Cancel();
    };

    Console.Title = $"Kafka Consumer [{config.GroupId}]";
    Console.Clear();

    try
    {
        while (true)
        {
            try
            {
                var cr = c.Consume(cts.Token);

                Console.WriteLine($"Message consumed [{cr.Partition}]/[@{cr.Offset}][{cr.Message.Key} : {cr.Message.Value}] - '{cr.TopicPartitionOffset}' - {cr.Message.Timestamp.UtcDateTime.ToLocalTime()}");

            }
            catch (ConsumeException e)
            {
                Console.WriteLine($"ERROR: {e.Error.Reason}");
            }

        }
    }
    catch (OperationCanceledException)
    {
        // Ensure that Consumer leaves the group safely and that the final offsets have been consumed.
        c.Close();
    }
}
