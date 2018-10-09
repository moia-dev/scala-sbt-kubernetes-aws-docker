# Dockerfile with Scala, SBT, Kubernetes, AWS CLI and Docker

This repository contains **Dockerfile** of:
* [Scala](http://www.scala-lang.org)
* [sbt](http://www.scala-sbt.org)
* [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/)
* [AWS CLI](https://aws.amazon.com/cli/)
* [Docker](https://www.docker.com/)

## Base Docker Image ##

* [openjdk](https://hub.docker.com/_/openjdk)

## Installation ##

1. Install [Docker](https://www.docker.com)
2. Pull [automated build](https://registry.hub.docker.com/u/moia/scala-sbt-kubernetes-aws-docker) from public [Docker Hub Registry](https://registry.hub.docker.com):
```
docker pull moia/scala-sbt-kubernetes-aws-docker
```
Alternatively, you can build an image from Dockerfile:
```
docker build -t moia/scala-sbt-kubernetes-aws-docker github.com/moia-dev/scala-sbt-kubernetes-aws-docker
```


## Usage ##

```
docker run -it --rm moia/scala-sbt-kubernetes-aws-docker
```

## Development Notes

### Building and publishing docker image

1. Pull latest version from github:

   ```
   git pull origin master
   git fetch --tags
   ```
2. Build Docker image:

   ```
   docker build -t moia/scala-sbt-kubernetes-aws-docker:8u171-2.12.7-1.2.3-1.10.4 .
   ```
3. Push Docker image:

   ```
   docker login
   docker push moia/scala-sbt-kubernetes-aws-docker:8u171-2.12.7-1.2.3-1.10.4
   ```

## License ##

This code is open source software licensed under the [Apache 2.0 License]("http://www.apache.org/licenses/LICENSE-2.0.html").
