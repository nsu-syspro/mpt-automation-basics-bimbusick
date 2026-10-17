FROM gcc:latest

RUN apt-get update && apt-get install -y make jq

WORKDIR /app
COPY . /app

RUN make check

CMD ["./build/wordcount"]
