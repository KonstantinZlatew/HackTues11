import socket

#ESP32 IP address from Serial Monitor
ESP32_IP = "192.168.214.66"  # Your ESP32’s IP
PORT = 80                    # Port 80 (matches ESP32 server)

#Create socket and connect
client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client_socket.connect((ESP32_IP, PORT))

print("Connected to ESP32")

try:
    while True:
        # Receive data (buffer size 1024 bytes)
        data = client_socket.recv(1024).decode('utf-8')
        if data:
            print("Received:", data.strip())  # Strip removes trailing newlines
except KeyboardInterrupt:
    print("\nDisconnected by user")
except Exception as e:
    print(f"Error: {e}")
finally:
    client_socket.close()
    print("Connection closed")