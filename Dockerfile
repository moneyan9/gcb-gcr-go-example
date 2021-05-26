FROM golang:1.16.3

WORKDIR /project

COPY ./go.* ./
RUN go mod download

COPY . ./

RUN CGO_ENABLED=0 GOOS=linux go install -v .

FROM alpine:latest

RUN apk --no-cache add ca-certificates

COPY --from=0 /go/bin/http-server /bin/http-server

RUN addgroup -g 1001 app && adduser -D -G app -u 1001 app

USER 1001

CMD ["/bin/http-server"]
