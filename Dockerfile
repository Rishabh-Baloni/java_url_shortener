FROM eclipse-temurin:21-jdk
WORKDIR /app
COPY . .
RUN chmod +x scripts/build-fat-jar.sh && ./scripts/build-fat-jar.sh
EXPOSE 8080
CMD ["java","-jar","app.jar"]

