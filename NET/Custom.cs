// Read latest messages
using (var c = new ConsumerBuilder<string, string>(config)
    .SetPartitionsAssignedHandler((c, ps) =>
    {
        return ps.Select(tp => new TopicPartitionOffset(tp, c.QueryWatermarkOffsets(tp, TimeSpan.FromSeconds(10)).High - 1));
        //restart from latest message (included) from all partition on all specificated topic
        // only with subscribe
    })
    .Build())
{
    c.Subscribe("Fabrizio");
    
    ...

}

// Read total Partitions number of a Topic
using (var adminClient = new AdminClientBuilder(new AdminClientConfig {

    BootstrapServers = "192.168.1.61:9092",
    ClientId = Dns.GetHostName()

}).Build())
{
    var meta = adminClient.GetMetadata(TimeSpan.FromSeconds(20));

    //var topic = meta.Topics.SingleOrDefault(t => t.Topic == "__consumer_offsets");
    var topic = meta.Topics.SingleOrDefault(t => t.Topic == "Fabrizio");

    var topicPartitions = topic.Partitions;

    for(int i=0;i<topicPartitions.Count;i++)
        Console.WriteLine(topicPartitions[i].PartitionId);
}
