# Dockerfile for creating a Docker image that contains the Linux x64 binary
#
# It makes use of multi-stage builds and requires Docker 17.05 or later:
# https://docs.docker.com/engine/userguide/eng-image/multistage-build/

# Builder image
# Don't bother to clean up the image - it's only used for building
FROM golang:1.10-alpine as builder

RUN apk add --no-cache upx

WORKDIR /go/src/serve
COPY serve.go .
RUN go env
# x86 necessary for busybox
RUN GOARCH=386 go build -ldflags="-s -w" -v
RUN upx --ultra-brute "serve"

# Runtime image
# Should be run like so:
# docker run --rm -v ${PWD}:/share --network "host" philippgille/serve
FROM busybox

LABEL maintainer "Philipp Gille"

COPY --from=builder /go/src/serve/serve ./

RUN mkdir "/share"

VOLUME ["/share"]
EXPOSE 8100

ENTRYPOINT ["./serve"]
CMD ["-d", "/share"]
