FROM python:3.12-alpine
RUN apk add --no-cache bash
WORKDIR /home/app
COPY . . 
COPY start.sh /usr/local/bin 
RUN chmod +x /usr/local/bin/start.sh
CMD ["start.sh"]