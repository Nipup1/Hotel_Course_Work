FROM alpine:latest  

RUN apk --no-cache add ca-certificates  

COPY user_service user_service

ENTRYPOINT ["/user_service"]  

EXPOSE 8083
