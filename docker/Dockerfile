# Dockerfile for creating a Docker image that contains the Linux x64 binary
#
# It makes use of multi-stage builds and requires Docker 17.05 or later:
# https://docs.docker.com/engine/userguide/eng-image/multistage-build/

# Builder image
# Don't bother to clean up the image - it's only used for building
FROM golang:1.12-alpine as builder

RUN apk add --no-cache upx

WORKDIR /go/src/app
COPY serve.go .

# Disable cgo for BusyBox
RUN CGO_ENABLED=0 go build -v -ldflags="-s -w"
RUN upx --ultra-brute "app"

# Runtime image
# Should be run like so:
# docker run --rm -v ${PWD}:/share --network "host" philippgille/serve
FROM busybox

LABEL maintainer "Philipp Gille"

COPY --from=builder /go/src/app/app serve

RUN mkdir "/share"

VOLUME ["/share"]
EXPOSE 8100

ENTRYPOINT ["./serve"]
CMD ["-d", "/share"]
