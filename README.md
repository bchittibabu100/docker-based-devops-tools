# docker-based-devops-tools
Docker files to build and run all the necessary tools inside docker container without installing them on local workstation/laptop

Steps to build and run docker container
1. git clone https://github.com/bchittibabu100/docker-based-devops-tools.git
2. cd docker-based-devops-tools
3. docker build . -t common-tools:latest
4. docker run -it -v <local-workspace-folder-to-mount>:/data common-tools:latest
