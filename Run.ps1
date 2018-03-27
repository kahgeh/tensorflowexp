param($path=$PSScriptRoot)
$imageName='tensorflowexp'

docker build . "-t=$imageName"  --platform=linux

$container=@(Get-Container)|where{$_.ports.PublicPort -eq '8888'}
if ( $container -ne $null )
{
    if((Read-Host "Do you want to kill $($container.Names) (y|n)?") -eq 'y' )
    {
        Write-Progress 'Cleaning up' -CurrentOperation 'kill' -PercentComplete 0
        docker kill $container.ID
        Write-Progress 'Cleaning up' -CurrentOperation 'prune' -PercentComplete 50
        docker system prune -f
        Write-Progress 'Cleaning up' -CurrentOperation 'done' -PercentComplete 100
    }
    else 
    {
        Write-Information 'Terminating without doing anything other than build the Dockerfile'
        exit    
    }
}

Write-Progress 'Starting container' -CurrentOperation 'start' -PercentComplete 0
docker run -d -v "$($path):/root/notebook" -p 8888:8888 -p 6006:6006 -e PASSWORD=p $imageName 

Write-Progress 'Starting container' -CurrentOperation 'done' -PercentComplete 100 