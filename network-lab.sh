#!bash

# clear namespaces
ip -all netns delete

# add namespaces
echo "adding nodes"
for node in $(jq '.nodes | keys[]' < "$1")
do
  # set up alias for later use
  alias "n${node:1:-1}"="ip netns exec netlab-${node:1:-1}"  
  ip netns add "netlab-${node:1:-1}"
done

# iterate over edges array
echo "adding edges"
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
  ip link set "veth-$A-$B" netns "netlab-$A"
  ip link set "veth-$B-$A" netns "netlab-$B"

  # add ip addresses on each side
  ipA=$(jq '.nodes["'$A'"].ip' < $1)
  ipB=$(jq '.nodes["'$B'"].ip' < $1)
  ip netns exec "netlab-$A" ip addr add ${ipA:1:-1} dev "veth-$A-$B"
  ip netns exec "netlab-$B" ip addr add ${ipB:1:-1} dev "veth-$B-$A"

  # bring the interfaces up
  ip netns exec "netlab-$A" ip link set dev "veth-$A-$B" up
  ip netns exec "netlab-$B" ip link set dev "veth-$B-$A" up

  # add some connection quality issues
  AtoB=$(jq '.edges['$i']["->"]' < $1)
  BtoA=$(jq '.edges['$i']["<-"]' < $1)

  ip netns exec "netlab-$A" tc qdisc add dev "veth-$A-$B" root netem ${AtoB:1:-1}
  ip netns exec "netlab-$B" tc qdisc add dev "veth-$B-$A" root netem ${BtoA:1:-1}
done

# run startup scripts
echo "running startup scripts"
for node in $(jq '.nodes | keys[]' < "$1")
do

  # don't error on empty script array
  scriptArr=$(jq '.nodes['$node'].startup' < $1)
  if [ "$scriptArr" = null ]; then
    true
  else

    # iterate through script array
    scripts=$(jq '.nodes['$node'].startup | values[]' < "$1")
    while read -r script; do
      echo "n${node:1:-1} \$" ${script:1:-1}
      ip netns exec "netlab-${node:1:-1}" ${script:1:-1}
    done <<< "$scripts"
  fi
done

alias jample="echo herp"