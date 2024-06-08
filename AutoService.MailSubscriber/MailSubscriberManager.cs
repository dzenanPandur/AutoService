using EasyNetQ;
using Microsoft.Extensions.Options;
using RabbitMQ.Client;
using System.Net;
using System.Net.Mail;

namespace AutoService.MailSubscriber
{
    public class MailSubscriberManager : BackgroundService
    {
        private readonly ILogger<MailSubscriberManager> logger;
        private readonly GmailSMTP gmailSMTPSettings;

        private readonly string _host = Environment.GetEnvironmentVariable("RABBITMQ_HOST") ?? "localhost";
        private readonly string _username = Environment.GetEnvironmentVariable("RABBITMQ_USERNAME") ?? "guest";
        private readonly string _password = Environment.GetEnvironmentVariable("RABBITMQ_PASSWORD") ?? "guest";
        private readonly string _virtualhost = Environment.GetEnvironmentVariable("RABBITMQ_VIRTUALHOST") ?? "/";

        public MailSubscriberManager(ILogger<MailSubscriberManager> logger, IOptions<GmailSMTP> gmailSMTPSettings, IConfiguration configuration)
        {
            this.logger = logger;
            this.gmailSMTPSettings = gmailSMTPSettings.Value;
        }




        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            while (!stoppingToken.IsCancellationRequested)
            {
                try
                {
                    using (var bus = RabbitHutch.CreateBus($"host={_host};virtualHost={_virtualhost};username={_username};password={_password}"))
                    {
                        bus.PubSub.Subscribe<AutoService.Data.DTO.ServiceData.EmailMessage>("email-queue", emailMessage =>
                        {
                            SendErrorMailAsync(emailMessage);
                        });
                        Console.WriteLine("Listening for email messages.");
                        await Task.Delay(TimeSpan.FromSeconds(5), stoppingToken);
                    }
                }
                catch (OperationCanceledException) when (stoppingToken.IsCancellationRequested)
                {
                    break;
                }
                catch (Exception ex)
                {
                    Console.WriteLine(ex.Message);
                }
            }

        }
        private void RabbitMQ_ConnectionShutdown(object sender, ShutdownEventArgs e) { }
        public Task SendErrorMailAsync(AutoService.Data.DTO.ServiceData.EmailMessage emailMessage)
        {

            string from = gmailSMTPSettings.From;
            string password = gmailSMTPSettings.Password;
            string host = gmailSMTPSettings.Host;
            string to = emailMessage.To;
            string subject = emailMessage.Subject;
            string body = emailMessage.Body;

            var client = new SmtpClient(host)
            {
                Port = 587,
                Credentials = new NetworkCredential(from, password),
                EnableSsl = true
            };

            var message = new MailMessage(from, to, subject, body);


            try
            {
                client.Send(message);
                logger.LogInformation($"Email sent");

            }
            catch (Exception ex)
            {
                logger.LogInformation("Failed to send email: " + ex.Message);
            }

            return Task.CompletedTask;
        }

        public override void Dispose()
        {
            base.Dispose();
        }


    }
}
