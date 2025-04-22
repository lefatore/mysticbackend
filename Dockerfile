# 1. Base Image für Go (zum Bauen)
FROM golang:1.24.2 as builder

# 2. Arbeitsverzeichnis im Container
WORKDIR /app

# 3. Abhängigkeiten und Quellcode kopieren
COPY go.mod go.sum ./
RUN go mod download

COPY . .

# 4. PocketBase Server bauen
RUN go build -o pocketbase

# 5. Minimales Image für Ausführung (kleiner, sicherer)
FROM alpine:latest

WORKDIR /app

RUN apk add --no-cache libc6-compat

# pb_data Ordner (falls du Daten speichern willst)
COPY --from=builder /app/pb_data ./pb_data

# Binary einfügen
COPY --from=builder /app/pocketbase .

# Port (Render verwendet z. B. 10000)
ENV PORT 10000

EXPOSE 10000

CMD ["./pocketbase", "serve", "--http=0.0.0.0:10000", "--cors-allow-origin=*"]