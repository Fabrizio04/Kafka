var config = new ConsumerConfig
{
    BootstrapServers = "192.168.1.61:9093",
    GroupId = "fabry",
    AutoOffsetReset = AutoOffsetReset.Earliest,

    SecurityProtocol = SecurityProtocol.Ssl,
    SslEndpointIdentificationAlgorithm = SslEndpointIdentificationAlgorithm.None,
    SslCaLocation = @"C:\Users\Fabrizio\Desktop\root.crt",
    SslCertificateLocation = @"C:\Users\Fabrizio\Desktop\producer_client.crt",
    SslKeyLocation = @"C:\Users\Fabrizio\Desktop\producer_client.key"

};