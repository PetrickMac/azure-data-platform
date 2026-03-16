# Device Simulator — Azure IoT Hub
# Simulates an edge device sending telemetry to IoT Hub.
# Messages are routed automatically to the telemetry-raw
# blob container in the Data Lake storage account.
#
# Usage:
#   1. Register a device in IoT Hub (Azure portal or CLI)
#   2. Copy the device connection string
#   3. Set IOTHUB_DEVICE_CONNECTION_STRING environment variable
#   4. Run: python device-simulator.py

import os
import time
import json
import random
from datetime import datetime, timezone
from azure.iot.device import IoTHubDeviceClient, Message

CONNECTION_STRING = os.environ.get("IOTHUB_DEVICE_CONNECTION_STRING")

if not CONNECTION_STRING:
    raise ValueError("IOTHUB_DEVICE_CONNECTION_STRING environment variable not set")

def generate_telemetry():
    """Simulate microgrid edge device telemetry"""
    return {
        "deviceId": "simulated-device-001",
        "timestamp": datetime.now(timezone.utc).isoformat(),
        "temperature": round(random.uniform(18.0, 85.0), 2),
        "voltage": round(random.uniform(110.0, 125.0), 2),
        "current": round(random.uniform(0.5, 15.0), 2),
        "powerOutput": round(random.uniform(0.0, 1000.0), 2),
        "status": random.choice(["running", "running", "running", "idle", "warning"]),
        "location": "Houston-Site-01"
    }

def main():
    print(f"Connecting to IoT Hub...")
    client = IoTHubDeviceClient.create_from_connection_string(CONNECTION_STRING)
    client.connect()
    print(f"Connected. Sending telemetry every 5 seconds. Press Ctrl+C to stop.\n")

    try:
        count = 0
        while True:
            count += 1
            payload = generate_telemetry()
            message = Message(json.dumps(payload))
            message.content_type = "application/json"
            message.content_encoding = "utf-8"
            client.send_message(message)
            print(f"[{count}] Sent: {json.dumps(payload, indent=2)}\n")
            time.sleep(5)

    except KeyboardInterrupt:
        print("\nStopped by user.")
    finally:
        client.disconnect()
        print("Disconnected.")

if __name__ == "__main__":
    main()