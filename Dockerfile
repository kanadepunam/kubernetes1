FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /app

COPY dotnet6.csproj .
RUN dotnet restore

RUN apt-get update && apt-get install -y nodejs npm


COPY . .
RUN dotnet build -c Release --no-restore
RUN dotnet publish -c Release -o publish --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
COPY --from=build /app/publish .

ENV ASPNETCORE_URLS=http://*:5000

RUN groupadd -r poonam && \
    useradd -r -g poonam -s /bin/false poonam && \
    chown -R poonam:poonam /app

USER poonam

EXPOSE 8080
ENTRYPOINT ["dotnet", "dotnet6.dll"]