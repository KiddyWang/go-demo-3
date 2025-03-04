FROM golang:1.18 AS build

ENV GO111MODULE=on
#ENV GOPROXY=https://goproxy.cn,direct

ADD . /src
WORKDIR /src

RUN go mod init modulename
RUN go mod tidy
RUN go test --cover -v ./... --run UnitTest
RUN go build -v -o go-demo


FROM alpine:3.15

RUN mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

EXPOSE 8080
ENV DB db
CMD ["go-demo"]

COPY --from=build /src/go-demo /usr/local/bin/go-demo
RUN chmod +x /usr/local/bin/go-demo
