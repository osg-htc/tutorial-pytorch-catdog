# Start from Nvidia PyTorch image
FROM nvcr.io/nvidia/pytorch:25.02-py3

# Update software repositories and install dependencies
ARG DEBIAN_FRONTEND="noninteractive"
ENV TZ=America/Chicago
RUN apt-get update -y
RUN apt-get install software-properties-common -y

# Copy only the requirements file first
COPY requirements.txt .

# Install dependencies
RUN python3 -m pip install -r requirements.txt

