# Hazelcast on docker

Running hazelcast on docker is easy. Getting hazelcast members to discover each other and form a cluster - not so much.

This project is intended to make it easy for anyone to run multiple hazelcast containers in tcp/ip discovery mode.
Refer to https://github.com/hazelcast/hazelcast/issues/9219 for list of issues.
```docker run --net=host``` is just bad, it won't scale.

I ended up parameterizing the public-address and tcp member list so that you can pass them as arguments to docker run command:

```
docker_ip=$(echo $DOCKER_HOST | sed 's,^.*/,,' | sed 's/:.*//')
docker run -e PUBLIC_IP=$docker_ip:40001 -e MEMBER_LIST=$docker_ip:40001,$docker_ip:40002 -p 40001:5701 <image-name>

```

For example, on my machine:
```
docker run -e PUBLIC_IP=192.168.99.100:40001 -e MEMBER_LIST=192.168.99.100:40001,192.168.99.100:40002 -p 40001:5701 gagangoku/hazelcast-docker
docker run -e PUBLIC_IP=192.168.99.100:40002 -e MEMBER_LIST=192.168.99.100:40001,192.168.99.100:40002 -p 40002:5701 gagangoku/hazelcast-docker
docker run -e PUBLIC_IP=192.168.99.100:40003 -e MEMBER_LIST=192.168.99.100:40001,192.168.99.100:40002 -p 40003:5701 gagangoku/hazelcast-docker

```

This makes a 3 node cluster and both hazelcast are able to talk to each other because of public address.

This could be simplified if we were able to access the port mapping from within docker container. It seems its an in-progress feature request on docker which might take a while: https://github.com/moby/moby/pull/26331

With moby's change, we would not fix a port, instead let docker use a dynamic port mapping and  construct the public ip from within the container itself.

Am still at a loss on how to construct the member list though. It probably has to be done via a discovery service.

