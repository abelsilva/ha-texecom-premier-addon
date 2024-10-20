ARG BUILD_FROM

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-container
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out

ARG BUILD_FROM
FROM ${BUILD_FROM}

WORKDIR /app

COPY --from=build-container /app/out .

CMD [ "/app/HaTexecomPremierAddon" ]