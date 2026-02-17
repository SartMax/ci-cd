FROM golang:1.25-alpine

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY *.go ./

# Устанавливаем gcc и sqlite для CGO
RUN apk add --no-cache gcc musl-dev sqlite

RUN CGO_ENABLED=1 GOOS=linux go build -o my_app

# Создаем таблицу и запускаем приложение
CMD sh -c "sqlite3 tracker.db 'CREATE TABLE IF NOT EXISTS parcel (number INTEGER PRIMARY KEY AUTOINCREMENT, client INTEGER NOT NULL, status TEXT NOT NULL, address TEXT NOT NULL, created_at TEXT NOT NULL);' && ./my_app"