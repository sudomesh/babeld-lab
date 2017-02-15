#!/bin/bash

usage() {
    echo `basename $0`: ERROR: $* 1>&2
    echo usage: `basename $0` '[add|up|down|delete|start|stop|up_bridge|down_bridge]'
    exit 1
}

BRIDGE=br-babel

add() {
  ip link add veth-p0 type veth peer name veth-n0
  ip link add veth-p1 type veth peer name veth-n1

  # create virtual switch by linux interface bridge
  brctl addbr $BRIDGE
  brctl stp   $BRIDGE off

  brctl addif $BRIDGE veth-p0
  brctl addif $BRIDGE veth-p1


  # move taps into different namespaces
  ip netns add n0
  ip netns add n1

  ip link set veth-n0 netns n0
  ip link set veth-n1 netns n1
  
  # assign ip address / subnet
  ip netns exec n0 ip addr add 170.30.100.2/24 dev veth-n0
  ip netns exec n1 ip addr add 170.30.101.2/24 dev veth-n1
}

state_eth() {
  # set links to up state 
  ip link set dev veth-p0 $1 
  ip link set dev veth-p1 $1
  
  ip netns exec n0 ip link set dev veth-n0 $1
  ip netns exec n1 ip link set dev veth-n1 $1
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
  ip netns exec n0 babeld -I babeld-n0.pid -d 3 -L babeld-n0.log veth-n0 &
  ip netns exec n1 babeld -I babeld-n1.pid -d 3 -L babeld-n1.log veth-n1 &
}

stop_babeld() {
  kill $(cat babel0.pid)
  kill $(cat babel1.pid)
}

delete() {
  # delete bridge
  brctl delbr $BRIDGE
  
  # delete virtual interfaces (this also removed the peers)
  ip link del veth-p0
  ip link del veth-p1

  ip netns delete n0
  ip netns delete n1
}


case $1 in
  "add") add;;
  "up") up_all;;
  "up_bridge") up_bridge;;
  "start") start_babeld;;
  "stop") stop_babeld;;
  "down") down_all;;
  "down_bridge") down_bridge;;
  "delete") delete;;
  *) usage;;
esac

