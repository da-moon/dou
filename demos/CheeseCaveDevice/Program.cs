// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

using System;
using Microsoft.Azure.Devices.Client;
using Microsoft.Azure.Devices.Provisioning.Client;
using Microsoft.Azure.Devices.Provisioning.Client.Transport;
using Microsoft.Azure.Devices.Shared;
using Newtonsoft.Json;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json.Linq;
using System.Security.Cryptography.X509Certificates;
using static CheeseCaveDevice.CheeseCaveSimulator;

namespace CheeseCaveDevice
{
    class Program
    {
        // Azure Device Provisioning Service (DPS) ID Scope
        private static string dpsIdScope = "0ne006EFAC9";

        // Certificate (PFX) File Name
        private static string certificateFileName = "cheese-cave-device.pfx";

        // Certificate (PFX) Password
        private static string certificatePassword = "tigerfis";

        private const string GlobalDeviceEndpoint = "global.azure-devices-provisioning.net";

        const int intervalInMilliseconds = 5000;                // Interval at which telemetry is sent to the cloud.

        // Global variables.
        private static DeviceClient deviceClient;

        private static CheeseCaveSimulator cheeseCave;

        // The device connection string to authenticate the device with your IoT hub.
        private readonly static string deviceConnectionString = "<your device connection string>";

        public static async Task Main(string[] args)
        {
            X509Certificate2 certificate = LoadProvisioningCertificate();

            using (var security = new SecurityProviderX509Certificate(certificate))
            using (var transport = new ProvisioningTransportHandlerAmqp(TransportFallbackType.TcpOnly))
            {
                ProvisioningDeviceClient provClient =
                    ProvisioningDeviceClient.Create(GlobalDeviceEndpoint, dpsIdScope, security, transport);

                using (deviceClient = await ProvisionDevice(provClient, security))
                {
                    await deviceClient.OpenAsync().ConfigureAwait(false);

                    // Setup device twin callbacks
                    await deviceClient
                        .SetDesiredPropertyUpdateCallbackAsync(OnDesiredPropertyChanged, null)
                        .ConfigureAwait(false);

                    ConsoleHelper.WriteColorMessage("Cheese Cave device app.\n", ConsoleColor.Yellow);

                    // Create an instance of the Cheese Cave Simulator
                    cheeseCave = new CheeseCaveSimulator();

                    // INSERT register direct method code below here
                    // Create a handler for the direct method call
                    deviceClient.SetMethodHandlerAsync("SetFanState", SetFanState, null).Wait();

                    // INSERT register desired property changed handler code below here
                    // Get the device twin to report the initial desired properties.
                    Twin deviceTwin = deviceClient.GetTwinAsync().GetAwaiter().GetResult();
                    ConsoleHelper.WriteGreenMessage("Initial twin desired properties: " + deviceTwin.Properties.Desired.ToJson());

                    // Set the device twin update callback.
                    deviceClient.SetDesiredPropertyUpdateCallbackAsync(OnDesiredPropertyChanged, null).Wait();

                    SendDeviceToCloudMessagesAsync();

                    Console.ReadLine();

                    await deviceClient.CloseAsync().ConfigureAwait(false);
                }
            }

            // ConsoleHelper.WriteColorMessage("Cheese Cave device app.\n", ConsoleColor.Yellow);

            // // Connect to the IoT hub using the MQTT protocol.
            // deviceClient = DeviceClient.CreateFromConnectionString(deviceConnectionString, TransportType.Mqtt);

            // // Create an instance of the Cheese Cave Simulator
            // cheeseCave = new CheeseCaveSimulator();

            // // INSERT register direct method code below here
            // // Create a handler for the direct method call
            // deviceClient.SetMethodHandlerAsync("SetFanState", SetFanState, null).Wait();

            // // INSERT register desired property changed handler code below here
            // // Get the device twin to report the initial desired properties.
            // Twin deviceTwin = deviceClient.GetTwinAsync().GetAwaiter().GetResult();
            // ConsoleHelper.WriteGreenMessage("Initial twin desired properties: " + deviceTwin.Properties.Desired.ToJson());

            // // Set the device twin update callback.
            // deviceClient.SetDesiredPropertyUpdateCallbackAsync(OnDesiredPropertyChanged, null).Wait();

            // SendDeviceToCloudMessagesAsync();
            // Console.ReadLine();
        }

        // The purpose of this method is to load the X.509 certificate from
        // disk. Should the load succeed, the method returns an instance of the
        // X509Certificate2 class.
        private static X509Certificate2 LoadProvisioningCertificate()
        {
            // The X509Certificate2 is a subclass of X509Certificate with
            // additional functionality that supports both V2 and V3 of the X509
            // standard.
            var certificateCollection = new X509Certificate2Collection();
            // The method creates an instance of the X509Certificate2Collection
            // class and then attempts to import the certificate file from disk,
            // using the the hard-coded password. The
            // X509KeyStorageFlags.UserKeySet values specifies that private keys
            // are stored in the current user store rather than the local
            // computer store. This occurs even if the certificate specifies
            // that the keys should go in the local computer store.
            certificateCollection.Import(certificateFileName,
                                         certificatePassword,
                                         X509KeyStorageFlags.UserKeySet);

            X509Certificate2 certificate = null;

            // The method iterates through the imported certificates (in this
            // case, there should only be one) and verifies that the certificate
            // has a private key. Should the imported certificate not match this
            // criteria, an exception is thrown, otherwise the method returns
            // the imported certificate.
            foreach (X509Certificate2 element in certificateCollection)
            {
                Console.WriteLine($"Found certificate: {element?.Thumbprint} {element?.Subject}; PrivateKey: {element?.HasPrivateKey}");
                if (certificate == null && element.HasPrivateKey)
                {
                    certificate = element;
                }
                else
                {
                    element.Dispose();
                }
            }

            // if (certificate == null)
            // {
            //     throw new FileNotFoundException($"{certificateFileName} did not contain any certificate with a private key.");
            // }

            Console.WriteLine($"Using certificate {certificate.Thumbprint} {certificate.Subject}");
            return certificate;
        }

        // This version of ProvisionDevice is very similar to that you used in
        // an earlier lab. The primary change is that the security parameter is
        // now of type SecurityProviderX509Certificate. This means that the auth
        // variable used to create a DeviceClient must now be of type
        // DeviceAuthenticationWithX509Certificate and uses the
        // security.GetAuthenticationCertificate() value. The actual device
        // registration is the same as before.
        private static async Task<DeviceClient> ProvisionDevice(
            ProvisioningDeviceClient provisioningDeviceClient,
            SecurityProviderX509Certificate security)
        {
            var result = await provisioningDeviceClient
                .RegisterAsync()
                .ConfigureAwait(false);
            Console.WriteLine($"ProvisioningClient AssignedHub: {result.AssignedHub}; DeviceID: {result.DeviceId}");
            if (result.Status != ProvisioningRegistrationStatusType.Assigned)
            {
                throw new Exception($"DeviceRegistrationResult.Status is NOT 'Assigned'");
            }

            var auth = new DeviceAuthenticationWithX509Certificate(
                result.DeviceId,
                security.GetAuthenticationCertificate());

            return DeviceClient.Create(result.AssignedHub, auth, TransportType.Amqp);
        }

        // Async method to send simulated telemetry.
        private static async void SendDeviceToCloudMessagesAsync()
        {
            while (true)
            {
                var currentTemperature = cheeseCave.ReadTemperature();
                var currentHumidity = cheeseCave.ReadHumidity();

                // Create JSON message.
                var telemetryDataPoint = new
                {
                    temperature = Math.Round(currentTemperature, 2),
                    humidity = Math.Round(currentHumidity, 2)
                };
                var messageString = JsonConvert.SerializeObject(telemetryDataPoint);
                var message = new Message(Encoding.ASCII.GetBytes(messageString));

                // Add custom application properties to the message.
                message.Properties.Add("sensorID", "S1");
                message.Properties.Add("fanAlert", (cheeseCave.FanState == StateEnum.Failed) ? "true" : "false");

                // Send temperature or humidity alerts, only if they occur.
                if (cheeseCave.IsTemperatureAlert)
                {
                    message.Properties.Add("temperatureAlert", "true");
                }
                if (cheeseCave.IsHumidityAlert)
                {
                    message.Properties.Add("humidityAlert", "true");
                }

                Console.WriteLine("Message data: {0}", messageString);

                // Send the telemetry message.
                await deviceClient.SendEventAsync(message);
                ConsoleHelper.WriteGreenMessage("Message sent\n");

                await Task.Delay(intervalInMilliseconds);
            }
        }

        // INSERT SetFanState method below here
        // Handle the direct method call
        private static Task<MethodResponse> SetFanState(MethodRequest methodRequest, object userContext)
        {
            if (cheeseCave.FanState == StateEnum.Failed)
            {
                // Acknowledge the direct method call with a 400 error message.
                string result = "{\"result\":\"Fan failed\"}";
                ConsoleHelper.WriteRedMessage("Direct method failed: " + result);
                return Task.FromResult(new MethodResponse(Encoding.UTF8.GetBytes(result), 400));
            }
            else
            {
                try
                {
                    var data = Encoding.UTF8.GetString(methodRequest.Data);

                    // Remove quotes from data.
                    data = data.Replace("\"", "");

                    // Parse the payload, and trigger an exception if it's not valid.
                    cheeseCave.UpdateFan((StateEnum)Enum.Parse(typeof(StateEnum), data));
                    ConsoleHelper.WriteGreenMessage("Fan set to: " + data);

                    // Acknowledge the direct method call with a 200 success message.
                    string result = "{\"result\":\"Executed direct method: " + methodRequest.Name + "\"}";
                    return Task.FromResult(new MethodResponse(Encoding.UTF8.GetBytes(result), 200));
                }
                catch
                {
                    // Acknowledge the direct method call with a 400 error message.
                    string result = "{\"result\":\"Invalid parameter\"}";
                    ConsoleHelper.WriteRedMessage("Direct method failed: " + result);
                    return Task.FromResult(new MethodResponse(Encoding.UTF8.GetBytes(result), 400));
                }
            }
        }

        // INSERT OnDesiredPropertyChanged method below here
        private static async Task OnDesiredPropertyChanged(TwinCollection desiredProperties, object userContext)
        {
            try
            {
                // Update the Cheese Cave Simulator properties
                cheeseCave.DesiredHumidity = desiredProperties["humidity"];
                cheeseCave.DesiredTemperature = desiredProperties["temperature"];
                ConsoleHelper.WriteGreenMessage("Setting desired humidity to " + desiredProperties["humidity"]);
                ConsoleHelper.WriteGreenMessage("Setting desired temperature to " + desiredProperties["temperature"]);

                // Report the properties back to the IoT Hub.
                var reportedProperties = new TwinCollection();
                reportedProperties["fanstate"] = cheeseCave.FanState.ToString();
                reportedProperties["humidity"] = cheeseCave.DesiredHumidity;
                reportedProperties["temperature"] = cheeseCave.DesiredTemperature;
                await deviceClient.UpdateReportedPropertiesAsync(reportedProperties);

                ConsoleHelper.WriteGreenMessage("\nTwin state reported: " + reportedProperties.ToJson());
            }
            catch
            {
                ConsoleHelper.WriteRedMessage("Failed to update device twin");
            }
        }

    }

    internal class CheeseCaveSimulator
    {
        internal enum StateEnum
        {
            Off,
            On,
            Failed
        }

        // Global constants.
        private const double ambientTemperature = 70;               // Ambient temperature of a southern cave, in degrees F.
        private const double ambientHumidity = 99;                  // Ambient humidity in relative percentage of air saturation.
        private const double desiredTempLimit = 5;                  // Acceptable range above or below the desired temp, in degrees F.
        private const double desiredHumidityLimit = 10;             // Acceptable range above or below the desired humidity, in percentages.

        // state variables
        private double currentTemperature = ambientTemperature;     // initial value is set to the ambient value
        private double currentHumidity = ambientHumidity;           // initial value is set to the ambient value

        Random rand = new Random();

        internal StateEnum FanState { get; private set; } = StateEnum.Off;

        internal bool IsTemperatureAlert => (currentTemperature > DesiredTemperature + desiredTempLimit) || (currentTemperature < DesiredTemperature - desiredTempLimit);

        internal bool IsHumidityAlert => (currentHumidity > DesiredHumidity + desiredHumidityLimit) || (currentHumidity < DesiredHumidity - desiredHumidityLimit);

        public double DesiredTemperature { get; set; } = ambientTemperature - 10; // Initial desired temperature, in degrees F.

        public double DesiredHumidity { get; set; } = ambientHumidity - 20; // Initial desired humidity in relative percentage of air saturation.

        public double ReadTemperature()
        {
            // Simulate telemetry.
            double deltaTemperature = Math.Sign(DesiredTemperature - currentTemperature);

            if (FanState == StateEnum.On)
            {
                // If the fan is on the temperature and humidity will be nudged towards the desired values most of the time.
                currentTemperature += (deltaTemperature * rand.NextDouble()) + rand.NextDouble() - 0.5;

                // Randomly fail the fan.
                if (rand.NextDouble() < 0.01)
                {
                    FanState = StateEnum.Failed;
                    ConsoleHelper.WriteRedMessage("Fan has failed");
                }
            }
            else
            {
                // If the fan is off, or has failed, the temperature and humidity will creep up until they reaches ambient values, thereafter fluctuate randomly.
                if (currentTemperature < ambientTemperature - 1)
                {
                    currentTemperature += rand.NextDouble() / 10;
                }
                else
                {
                    currentTemperature += rand.NextDouble() - 0.5;
                }
            }

            return currentTemperature;
        }

        public double ReadHumidity()
        {
            // Simulate telemetry.
            double deltaHumidity = Math.Sign(DesiredHumidity - currentHumidity);

            if (FanState == StateEnum.On)
            {
                // If the fan is on the temperature and humidity will be nudged towards the desired values most of the time.
                currentHumidity += (deltaHumidity * rand.NextDouble()) + rand.NextDouble() - 0.5;

                // Randomly fail the fan.
                if (rand.NextDouble() < 0.01)
                {
                    FanState = StateEnum.Failed;
                    ConsoleHelper.WriteRedMessage("Fan has failed");
                }
            }
            else
            {
                // If the fan is off, or has failed, the temperature and humidity will creep up until they reaches ambient values, thereafter fluctuate randomly.
                if (currentHumidity < ambientHumidity - 1)
                {
                    currentHumidity += rand.NextDouble() / 10;
                }
                else
                {
                    currentHumidity += rand.NextDouble() - 0.5;
                }
            }

            // Check: humidity can never exceed 100%.
            currentHumidity = Math.Min(100, currentHumidity);

            return currentHumidity;
        }

        internal void UpdateFan(StateEnum newState)
        {
            // in a real device, this method would contain logic to start/stop
            // a fan and determine whether it was successful

            FanState = newState;
        }
    }

    internal static class ConsoleHelper
    {
        internal static void WriteColorMessage(string text, ConsoleColor clr)
        {
            Console.ForegroundColor = clr;
            Console.WriteLine(text);
            Console.ResetColor();
        }
        internal static void WriteGreenMessage(string text)
        {
            WriteColorMessage(text, ConsoleColor.Green);
        }

        internal static void WriteRedMessage(string text)
        {
            WriteColorMessage(text, ConsoleColor.Red);
        }
    }
}