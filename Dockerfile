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

# Install requirements for add-on
RUN apk add --no-cache aspnetcore8-runtime

COPY ./run.sh /app/run.sh
RUN chmod a+x /app/run.sh

COPY --from=build-container /app/out .

CMD [ "/app/run.sh" ]