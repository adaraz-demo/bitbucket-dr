FROM ubuntu:18.04

RUN apt-get update && apt-get install -y sudo curl && \
      curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash