FROM alpine:latest  

RUN apk --no-cache add ca-certificates  

COPY auth_service auth_service
COPY .env .env  

ENTRYPOINT ["/auth_service"]  

EXPOSE 8082
