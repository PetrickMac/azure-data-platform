FROM python:3.11-slim
WORKDIR /app
COPY docs/device-simulator.py .
RUN pip install azure-iot-device
CMD ["python", "device-simulator.py"]
