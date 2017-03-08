#!/bin/bash

usage() {
    echo `basename $0`: ERROR: $* 1>&2
    echo usage: `basename $0` '[ -a = add | -u = up | -d = down | -r = delete | -s = start | -e = stop ]'
    exit 1
}

BRIDGE=br-babel

add() {

  brctl addbr $BRIDGE
  brctl stp   $BRIDGE on

  #create variable number of nodes and proxies based on user input
  list_nodes=( $(get_nodes) )
  let "nodes=(${#list_nodes[@]})"
  let "newnodes=($nodes+$1)"
  for ((i=$nodes; i<$newnodes; i++)); do
    proxy="veth-p"$i
    node="veth-n"$i
    echo $proxy": created"
    echo $node": added to "$BRIDGE
    ip link add $proxy type veth peer name $node

    # create virtual switch by linux interface bridge
    brctl addif $BRIDGE $proxy

    # move taps into different namespaces
    ip netns add n$i

    ip link set $node netns n$i
    let "subnet=(100+$i)"
    # assign ip address / subnet
    ip netns exec n$i ip addr add 170.30.$subnet.2/24 dev $node

  done
}

get_nodes(){

  #set array delimiter to blank space
  IFS=" "

  # generate the current number of nodes(really proxies) as an array
  ip addr | grep "veth-[np][0-9]" | awk '{ print $2 }' | awk -F@ '{ print $1 }' | xargs echo


}

state_eth() {

  list_nodes=( $(get_nodes) )

  #loop through all nodes by their index
  for i in "${!list_nodes[@]}"; do
    
    proxy="veth-p"$i
    node="veth-n"$i

    # set links to state up or state down 
    ip link set dev $proxy $1 
  
    ip netns exec n$i ip link set dev $node $1

    echo $node": set to state "$1

  done
}

state_bridge() {
  ip link set dev $BRIDGE $1
}

up_all() {
  state_eth 'up'
  state_bridge 'up'
}

up_bridge() {
  state_bridge 'up'
}

down_all() {
  state_eth 'down'
  state_bridge 'down'
}

down_bridge() {
  state_bridge 'down'
}

start_babeld() {
  lstp=( $( get_nodes ) )
  for i in "${!lstp[@]}"; do
    ip netns exec n$i babeld -I babeld-n$i.pid -d 3 -L babeld-n$i.log veth-n$i &
    echo "veth-n"$i": babeld process started"
  done
}

stop_babeld() {
  list_nodes=( $( get_nodes ) )
  for i in "${!list_nodes[@]}"; do
    kill $(cat babeld-n$i.pid)
    echo "veth-n"$i": babeld process ended"
  done
  #delete all pid and log files associated with previous babel session
  ls | grep babeld-n | xargs rm
}

delete() {

  # don't delete bridge (may need separate delete bridge function)
  #brctl delbr $BRIDGE

  # delete variable number of nodes based on user input 
  list_nodes=( $(get_nodes) )
  let "nodes=(${#list_nodes[@]}-1)"
  let "newnodes=($nodes-$1)"
  for ((i=$nodes; i>=$newnodes; i--)); do
    # delete virtual interfaces (this also removed the peers)
    ip link del veth-p$i
    ip netns delete n$i
    echo "node "$i" removed from mesh"
  done
}


while getopts ":a:usedr:" opt; do
   case $opt in
      a ) add $OPTARG;;
      u ) up_all;;
      s ) start_babeld;;
      e ) stop_babeld;;
      d ) down_all;;
      r ) delete $OPTARG;;
      * ) usage;;
   esac
done


#case $1 in
#  "add") add;;
#  "up") up_all;;
#  "up_bridge") up_bridge;;
#  "start") start_babeld;;
#  "stop") stop_babeld;;
#  "down") down_all;;
#  "down_bridge") down_bridge;;
#  "delete") delete;;
#  *) usage;;
#esac

