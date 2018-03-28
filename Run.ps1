param($path=$PSScriptRoot)
$imageName='tensorflow/tensorflow'

$container=@(Get-Container) | Where-Object {$_.ports.PublicPort -eq '8888'}
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
        Write-Information 'Terminating'
        exit    
    }
}

Write-Progress 'Starting container' -CurrentOperation 'start' -PercentComplete 0
$containerId=docker run -d -v "$($path):/notebooks" -p 8888:8888 -p 6006:6006 -e PASSWORD=p $imageName
Write-Progress 'Starting container' -CurrentOperation 'done' -PercentComplete 100 
docker exec -it $containerId bash 
