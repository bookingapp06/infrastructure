{
    "AWSEBDockerrunVersion": "1",
    "Image": {
      "Name": "${image_name}",
      "Update": "true"
    },
    "Ports": [
      {
        "ContainerPort": "3333",
        "HostPort": "80"
      }
    ]
  }
