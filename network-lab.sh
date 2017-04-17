#!bash

# clear namespaces
ip -all netns delete

# add namespaces
for node in $(jq '.nodes | keys[]' < "$1")
do
  ip netns add "ns-${node:1:-1}"
done

# iterate over edges array
length=$(jq '.edges | length' < $1)
for ((i=0; i<$length; i++)); do

  # get names of nodes
  A=$(jq '.edges['$i'].nodes[0]' < $1)
  B=$(jq '.edges['$i'].nodes[1]' < $1)
  A=${A:1:-1}
  B=${B:1:-1}

  # create veth to link them
  ip link add "veth-$A-$B" type veth peer name "veth-$B-$A"

  # assign each side of the veth to one of the nodes namespaces
  ip link set "veth-$A-$B" netns "ns-$A"
  ip link set "veth-$B-$A" netns "ns-$B"

  # add ip addresses on each side
  ipA=$(jq '.nodes["'$A'"].ip' < $1)
  ipB=$(jq '.nodes["'$B'"].ip' < $1)
  ip netns exec "ns-$A" ip addr add ${ipA:1:-1} dev "veth-$A-$B"
  ip netns exec "ns-$B" ip addr add ${ipB:1:-1} dev "veth-$B-$A"

  # bring the interfaces up
  ip netns exec "ns-$A" ip link set dev "veth-$A-$B" up
  ip netns exec "ns-$B" ip link set dev "veth-$B-$A" up

  # add some connection quality issues
  AtoB=$(jq '.edges[0]["->"]' < $1)
  BtoA=$(jq '.edges[0]["<-"]' < $1)

  ip netns exec "ns-$A" tc qdisc add dev "veth-$A-$B" root netem ${AtoB:1:-1}
  ip netns exec "ns-$B" tc qdisc add dev "veth-$B-$A" root netem ${BtoA:1:-1}
done

# run startup scripts
for node in $(jq '.nodes | keys[]' < "$1")
do
  script=$(jq '.nodes['$node'].startup' < $1)

  if [ "$script" = null ]; then
    true
  else
    ip netns exec "ns-${node:1:-1}" ${script:1:-1}
  fi
done
