FROM registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift

COPY . ./
RUN ./gradlew build && rm -rf ~/.gradle ./.gradle && chmod +x ./build/libs/flr-gateway-0.0.1.jar

EXPOSE 8080

CMD ./build/libs/flr-gateway-0.0.1.jar
