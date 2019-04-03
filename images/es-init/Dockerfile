FROM alpine
RUN apk add --update curl
COPY . /src
WORKDIR /src
CMD ./scripts/insert_big_cities.sh http://elasticsearch:9200
