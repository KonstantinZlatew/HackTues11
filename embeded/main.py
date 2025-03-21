import asyncio
import websockets
import time
import json
import random

#ESP32 IP address from Serial Monitor
ESP32_IP = "192.168.214.66"  # Your ESP32’s IP
PORT = 80                    # Port 80 (matches ESP32 server)
SERVER_HOST = "0.0.0.0"       # Listen on all available interfaces
SERVER_PORT = 8080            # WebSocket server port

clients = set()  # Using a set to keep track of connected WebSocket clients

suggested_crops = ["Tomatoes", "Potatoes", "Rice", "Wheat", "Corn"]
nitrogen_values = ["45 mg/kg", "50 mg/kg", "55 mg/kg", "40 mg/kg", "60 mg/kg"]
phosphorus_values = ["30 mg/kg", "35 mg/kg", "40 mg/kg", "25 mg/kg", "45 mg/kg"]
potassium_values = ["50 mg/kg", "55 mg/kg", "60 mg/kg", "45 mg/kg", "70 mg/kg"]
ph_values = ["6.5", "7.0", "6.8", "7.2", "6.9"]
ec_values = ["1.2 dS/m", "1.3 dS/m", "1.1 dS/m", "1.5 dS/m", "1.4 dS/m"]
temperature_values = ["22°C", "23°C", "25°C", "20°C", "24°C"]
humidity_values = ["45%", "50%", "55%", "60%", "65%"]

async def listen_to_esp32(ip: str, port: int):
    """Simulate listening to ESP32 and sending mock data to connected WebSocket clients"""
    print("Connected to ESP32")

    while True:
        await asyncio.sleep(5)
        # Simulated data from ESP32
        data = {
            "Suggested Crop": random.choice(suggested_crops),
            "Nitrogen (N)": random.choice(nitrogen_values),
            "Phosphorus (P)": random.choice(phosphorus_values),
            "Potassium (K)": random.choice(potassium_values),
            "pH Level": random.choice(ph_values),
            "Electrical Conductivity (EC)": random.choice(ec_values),
            "temperature": random.choice(temperature_values),
            "humidity": random.choice(humidity_values)
        }

        #print("Received:", data)  # Strip removes trailing newlines
        
        # Convert the data to JSON format
        json_data = json.dumps(data)
        #print("Sending:", json_data)

        # Send the data to all connected WebSocket clients
        for client in clients.copy():  # Iterate over a copy of the set
            try:
                await client.send(json_data)
            except (websockets.exceptions.ConnectionClosed, Exception) as e:
                print(f"Error sending to client: {e}")
                #clients.remove(client)  # Remove disconnected clients

async def serve_clients():
    """Start a WebSocket server to listen for incoming client connections."""
    server = await websockets.serve(handle_client, SERVER_HOST, SERVER_PORT)
    print(f"WebSocket server listening on {SERVER_HOST}:{SERVER_PORT}")
    await asyncio.Future()  # Keep the server running

async def handle_client(websocket):
    """Handle a new WebSocket connection."""
    print(f"New connection from {websocket.remote_address}")
    clients.add(websocket)

    try:
        while True:
            message = await websocket.recv()
            print(f"Received message from client: {message}")
    except websockets.exceptions.ConnectionClosed as e:
        print(f"Client {websocket.remote_address} disconnected: {e}")
    finally:
        clients.remove(websocket)  # Remove the client from the set when it disconnects

# Start the WebSocket server and listen for ESP32 data
async def main():
    # Run both the WebSocket server and ESP32 listening function concurrently
    await asyncio.gather(
        serve_clients(),
        listen_to_esp32(ESP32_IP, PORT)
    )

# Run the asyncio event loop
if __name__ == "__main__":
    asyncio.run(main())
