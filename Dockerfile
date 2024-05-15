
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 7264
ENV ASPNETCORE_URLS=http://+:7264

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY . .


FROM build AS publish
RUN dotnet publish "AutoService/AutoService.csproj" -c Release -o /app
FROM base AS final
WORKDIR /app
COPY --from=publish /app .

ENTRYPOINT ["dotnet", "AutoService.dll"]