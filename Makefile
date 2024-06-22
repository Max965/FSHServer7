build:
	dotnet build
start:
	dotnet run --project src/Host/Host.csproj
nuget:
	nuget pack -NoDefaultExcludes -OutputDirectory nupkg
publish:
	dotnet publish --os linux --arch x64 -c Release --self-contained
publish-to-hub:
	dotnet publish --os linux --arch x64 -c Release -p:ContainerRegistry=docker.io -p:ContainerImageName=iammukeshm/dotnet-webapi --self-contained
tp: # terraform plan
	cd terraform/environments/staging && terraform plan
ta: # terraform apply
	cd terraform/environments/staging && terraform apply
td: # terraform destroy
	cd terraform/environments/staging && terraform destroy
dcu: # docker-compose up : webapi + postgresql
	cd docker-compose/ && docker-compose -f docker-compose.postgresql.yml up -d
dcd: # docker-compose down : webapi + postgresql
	cd docker-compose/ && docker-compose -f docker-compose.postgresql.yml down
fds: # force rededeploy aws ecs service
	aws ecs update-service --force-new-deployment --service dotnet-webapi --cluster fullstackhero
gw: # git docker workflow to push docker image to the repository based on the main branch
	@echo triggering github workflow to push docker image to container
	@echo ensure that you have the gh-cli installed and authenticated.
	gh workflow run dotnet-cicd -f push_to_docker=true

#run from
C:\Users\Miles\source\repos\fshwebapi>
#docker run -d -p 5100:5100 -p 5010:5010 -v C:/Users/Miles/source/repos/fshwebapi/src/Host/https:/https web api:latest
#docker run -d -p 5100:5100 -p 5010:5010 -e ASPNETCORE_ENVIRONMENT=docker -e ASPNETCORE_URLS="https://+:5100;http://+:5010" -e ASPNETCORE_HTTPS_PORT=5100 -e ASPNETCORE_Kestrel__Certificates__Default__Password=password! -e ASPNETCORE_Kestrel__Certificates__Default__Path=/https/cert.pfx -v C:/Users/Miles/source/repos/fshwebapi/src/Host/https:/https webapi:latest
