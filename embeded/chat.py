import asyncio
import websockets
import json
import openai
import os
from dotenv import load_dotenv


load_dotenv()
api_token = os.getenv("API_KEY")

openai.api_key = api_token

def inf_about_plant(plant: str):
    prompt = f"""
    You are a smart agriculture assistant. 
    You will be given different types of plants, for example corn, beans etc. I want you to give values of the variables that an NPK sensor gives 
    ( temperature, humidity, N, P, K, pH, EC), formulated in short answers, so that it would be perfect for that plant to grow. 
    Give the temperature in Celsius. 
    Every single parameter should be in a new line. Give the N, P, K values in ppm. 
    If something is not a plant, you shouldn't give information about that and say that this is not a living thing. 
    If you can extract the data of the site with priority. If you can't find it generate it from your general knowledge.

    plant = {plant}

    Context:
    You will be given different types of plants, for example corn, beans etc. I want you to give values of the variables that an NPK sensor gives 
    ( temperature, humidity, N, P, K, pH, EC), formulated in short answers, so that it would be perfect for that plant to grow. 
    Give the temperature in Celsius. 
    Every single parameter should be in a new line. Give the N, P, K values in ppm. 
    If something is not a plant, you shouldn't give information about that and say that this is not a living thing.
    """

    try:
        
        response = openai.Completion.create(
            model="gpt-3.5-turbo",  
            prompt=prompt,
            temperature=0.3,
            max_tokens=300
        )
        return response['choices'][0]['text'].strip()
    except Exception as e:
        return f"Error: {e}"


async def handle_client(websocket):
    print(f"Client connected: {websocket.remote_address}")
    try:
        async for message in websocket:
            data = json.loads(message)
            plant_name = data.get("plant")
            
            if plant_name:
                plant_info = inf_about_plant(plant_name)
                await websocket.send(json.dumps({"ai_response": plant_info}))
            else:
                await websocket.send(json.dumps({"ai_response": "Please provide a plant name!"}))
    except Exception as e:
        print(f"Error handling client: {e}")
    finally:
        print(f"Client disconnected: {websocket.remote_address}")


async def main():
    print("Starting WebSocket server on ws://0.0.0.0:8765")
    async with websockets.serve(handle_client, "0.0.0.0", 8765):
        await asyncio.Future()  

if __name__ == "__main__":
    asyncio.run(main())
