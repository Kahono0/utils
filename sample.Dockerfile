FROM golang:1.23 AS builder

WORKDIR /app

# Copy Go modules manifests and download dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy application source code
COPY . .

# Build the Go application
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o main main.go

# Step 2: Use a minimal runtime image
FROM alpine:latest

WORKDIR /app

# Install necessary runtime dependencies (if needed)
RUN apk --no-cache add ca-certificates

# Copy the built binary and .env file
COPY --from=builder /app/main .

RUN chmod +x main
# Run the application
ENTRYPOINT ["./main"]

