
using AutoService.MailSubscriber;

IHost host = Host.CreateDefaultBuilder(args)
    .ConfigureServices((hostContext, services) =>
    {
        services.Configure<GmailSMTP>(hostContext.Configuration.GetSection("GmailSMTP"));

        services.AddHostedService<MailSubscriberManager>();
    })
    .Build();

await host.RunAsync();