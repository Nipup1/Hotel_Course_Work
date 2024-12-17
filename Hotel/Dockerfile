FROM alpine:latest  

RUN apk --no-cache add ca-certificates  

COPY hotel_service hotel_service

ENTRYPOINT ["/hotel_service"]  

EXPOSE 8084
