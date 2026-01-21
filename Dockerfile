FROM eclipse-temurin:21-jdk
WORKDIR /app
COPY . .
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/* && chmod +x scripts/build-fat-jar.sh && ./scripts/build-fat-jar.sh
EXPOSE 8080
CMD ["java","-cp","app.jar:lib/*","app.Main"]
