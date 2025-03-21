import asyncio
import websockets
import json
import random

# Server configuration
SERVER_HOST = "0.0.0.0"
SENSOR_PORT = 8080  # Soil sensor service
CHAT_PORT = 8081  # AI chat service

# Connected WebSocket clients
sensor_clients = set()
chat_clients = set()

# Dummy sensor data values
suggested_crops = ["Tomatoes", "Potatoes", "Rice", "Wheat", "Corn"]
nitrogen_values = ["45 mg/kg", "50 mg/kg", "55 mg/kg", "40 mg/kg", "60 mg/kg"]
phosphorus_values = ["30 mg/kg", "35 mg/kg", "40 mg/kg", "25 mg/kg", "45 mg/kg"]
potassium_values = ["50 mg/kg", "55 mg/kg", "60 mg/kg", "45 mg/kg", "70 mg/kg"]
ph_values = ["6.5", "7.0", "6.8", "7.2", "6.9"]
ec_values = ["1.2 dS/m", "1.3 dS/m", "1.1 dS/m", "1.5 dS/m", "1.4 dS/m"]
temperature_values = ["22°C", "23°C", "25°C", "20°C", "24°C"]
humidity_values = ["45%", "50%", "55%", "60%", "65%"]

# AI Chat Responses
ai_responses = {
    "tomato": "Tomatoes require well-drained soil with a pH of 6.2 to 6.8. Ensure proper nitrogen levels and provide ample sunlight for best growth.",
    "potato": "Potatoes grow best in loose, well-drained soil with a pH between 5.0 and 6.0. They need moderate nitrogen and high phosphorus and potassium levels.",
    "best crop for sandy soil": "Sandy soil is well-suited for crops like carrots, radishes, peanuts, and watermelon because it drains well and warms up quickly."
}

# ---------------- Soil Sensor Service (PORT 8080) ---------------- #

async def send_sensor_data():
    """Send mock sensor data to connected WebSocket clients."""
    while True:
        await asyncio.sleep(20)
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

        json_data = json.dumps(data)
        print(f"Sending sensor data: {json_data}")

        for client in sensor_clients.copy():
            try:
                await client.send(json_data)
            except (websockets.exceptions.ConnectionClosed, Exception) as e:
                print(f"Error sending to client: {e}")
                sensor_clients.remove(client)

async def handle_sensor_client(websocket):
    """Handle a new WebSocket client for sensor data."""
    print(f"New sensor client connected: {websocket.remote_address}")
    sensor_clients.add(websocket)
    
    try:
        while True:
            await websocket.recv()  # Just keep the connection alive
    except websockets.exceptions.ConnectionClosed:
        print(f"Sensor client {websocket.remote_address} disconnected")
    finally:
        sensor_clients.remove(websocket)

async def start_sensor_server():
    """Start WebSocket server for sensor data."""
    server = await websockets.serve(handle_sensor_client, SERVER_HOST, SENSOR_PORT)
    print(f"Sensor data WebSocket server listening on {SERVER_HOST}:{SENSOR_PORT}")
    await asyncio.Future()  # Keep the server running

# ---------------- AI Chat Service (PORT 8081) ---------------- #

async def handle_chat_client(websocket):
    """Handle AI chat WebSocket connections."""
    print(f"New chat client connected: {websocket.remote_address}")
    chat_clients.add(websocket)

    try:
        async for message in websocket:
            print(f"Received from chat client: {message}")
            
            try:
                data = json.loads(message)
                vegetable = data.get("vegetable", "").lower()

                response_text = ai_responses.get(vegetable, "I'm sorry, I don't have information on that vegetable yet.")
                response = json.dumps({"response": response_text})

                await websocket.send(response)
                print(f"Sent AI response: {response}")

            except json.JSONDecodeError:
                await websocket.send(json.dumps({"response": "Invalid request format. Please send JSON."}))
    except websockets.exceptions.ConnectionClosed:
        print(f"Chat client {websocket.remote_address} disconnected")
    finally:
        chat_clients.remove(websocket)

async def start_chat_server():
    """Start WebSocket server for AI chat service."""
    server = await websockets.serve(handle_chat_client, SERVER_HOST, CHAT_PORT)
    print(f"Chat AI WebSocket server listening on {SERVER_HOST}:{CHAT_PORT}")
    await asyncio.Future()  # Keep the server running

# ---------------- Run Both Servers ---------------- #

async def main():
    """Run both WebSocket servers concurrently."""
    await asyncio.gather(
        start_sensor_server(),
        start_chat_server(),
        send_sensor_data()
    )

if __name__ == "__main__":
    asyncio.run(main())
