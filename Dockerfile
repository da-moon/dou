FROM golang:1.16

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod tidy
RUN go get github.com/gorilla/mux
RUN go get github.com/rs/cors

COPY *.go ./
ENV AUTH_TOKEN=YOUR-TOKEN

RUN go build -o /docker-gs-ping

EXPOSE 8000

CMD [ "/docker-gs-ping" ]