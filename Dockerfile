
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /sln

EXPOSE 80
EXPOSE 443

# Copy project file and restore
COPY "./src/packagedemoapp/package-demo.csproj" "./src/packagedemoapp/"
RUN dotnet restore ./src/packagedemoapp/package-demo.csproj

# Copy the actual source code
COPY "./src/packagedemoapp" "./src/packagedemoapp"

# Build and publish the app
RUN dotnet publish "./src/packagedemoapp/package-demo.csproj" -c Release -o /app/publish

#FINAL image
FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "package-demo.dll"]