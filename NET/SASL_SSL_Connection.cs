var config = new ConsumerConfig
{
    BootstrapServers = "192.168.1.61:9094",
    GroupId = "fabrynew",
    AutoOffsetReset = AutoOffsetReset.Earliest,

    SaslMechanism = SaslMechanism.Plain,
    SecurityProtocol = SecurityProtocol.SaslSsl,
    SaslUsername = "admin",
    SaslPassword = "admin-secret",

    SslEndpointIdentificationAlgorithm = SslEndpointIdentificationAlgorithm.None,
    SslCaLocation = @"C:\Users\Fabrizio\Desktop\root.crt",
    SslCertificateLocation = @"C:\Users\Fabrizio\Desktop\consumer_client.crt",
    SslKeyLocation = @"C:\Users\Fabrizio\Desktop\consumer_client.key"

};