# Stage 1: Build the Go application
FROM golang:1.22 AS builder
WORKDIR /app
COPY . .
RUN go mod download
RUN go build -o whisper-api cmd/app/main.go

# Stage 2: Create the final image
FROM ubuntu:20.04
WORKDIR /app

# Install basic dependencies
RUN apt-get update && \
    apt-get install -y ffmpeg && \
    apt-get clean

COPY --from=builder /app/whisper-api /app/whisper-api

# Make the binary executable
RUN chmod +x /app/whisper-api

# Expose port 8080 for the API server
EXPOSE 8080

CMD ["./whisper-api"]
