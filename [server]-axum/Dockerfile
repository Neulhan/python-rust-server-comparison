# Build stage
FROM rust:1.74 as builder
WORKDIR /app
COPY . .
RUN cargo build --release

# Runtime stage
FROM debian:buster-slim
WORKDIR /app
COPY --from=builder /app/target/release/my_app .
CMD ["./my_app"]
