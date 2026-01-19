# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy csproj and restore as distinct layers
COPY PruebaPrometheus.csproj ./
RUN dotnet restore ./PruebaPrometheus.csproj

# Copy the rest of the source
COPY . .

# Publish
RUN dotnet publish PruebaPrometheus.csproj -c Release -o /app/publish --no-restore

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

# Expose application port
EXPOSE 5000

# Configure Kestrel to listen on 0.0.0.0:5000
ENV ASPNETCORE_URLS=http://0.0.0.0:5000

# Copy published app
COPY --from=build /app/publish .

# Start the application
ENTRYPOINT ["dotnet", "PruebaPrometheus.dll"]
