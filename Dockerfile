FROM --platform=$TARGETPLATFORM golang:1.21.1-alpine AS builder
ARG TARGETPLATFORM

# Download and install the latest release of dep
# ADD https://github.com/golang/dep/releases/download/v0.5.0/dep-linux-amd64 /usr/bin/dep
# RUN chmod +x /usr/bin/dep

RUN apk add --update git \
    && rm -rf /var/cache/apk/*

WORKDIR $GOPATH/src/github.com/aaronkvanmeerten/resec/
COPY go.mod go.sum ./
RUN go mod download
COPY . ./

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o build/resec  .

FROM --platform=$TARGETPLATFORM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /go/src/github.com/aaronkvanmeerten/resec/build/resec .
CMD ["./resec"]
