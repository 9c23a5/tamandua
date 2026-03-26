FROM crystallang/crystal:latest-alpine AS build
WORKDIR /src
COPY . .
RUN mkdir -p release
RUN make shards
RUN crystal build src/tamandua.cr --release --no-debug --progress --static -o /tamandua && strip /tamandua

FROM scratch
COPY --from=build /tamandua /tamandua
