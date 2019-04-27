# Dockerfile for creating a Docker image that contains the Linux x64 binary
#
# It makes use of multi-stage builds and requires Docker 17.05 or later:
# https://docs.docker.com/engine/userguide/eng-image/multistage-build/

# Builder image
FROM golang:1.12-alpine as builder

RUN apk add --no-cache upx

WORKDIR /go/src/app
COPY *.go ./

# Disable cgo for scratch
RUN CGO_ENABLED=0 go build -v -ldflags="-s -w"
RUN upx --ultra-brute "app"

# Runtime image
FROM scratch

LABEL maintainer "Philipp Gille"

COPY --from=builder /go/src/app/app serve
# Required to have an empty "srv" directory.
# `RUN mkdir /srv` doesn't work in scratch.
COPY --from=builder /var/empty /srv

VOLUME ["/srv"]
EXPOSE 8080 8443

ENTRYPOINT ["./serve", "-d", "/srv"]
