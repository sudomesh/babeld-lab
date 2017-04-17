#!bash

# {
#   "nodes": [1, 2, 3],
#   "edges": [
#     {
#       "nodes": [1, 2],
#       "->": 'delay 10ms 20ms distribution normal',
#       "<-": 'delay 500ms 20ms distribution normal'
#     },
#     {
#       "nodes": [2, 3],
#       "->": 'delay 10ms 20ms distribution normal',
#       "<-": 'delay 500ms 20ms distribution normal'
#     }
#   ]
# }

# goal: ping from one namespace to another

echo "clear namespaces"
ip -all netns delete

echo "add namespaces"
ip netns add ns1
ip netns add ns2
ip netns add ns3

echo "create veth to link them"
ip link add veth1-2 type veth peer name veth2-1

ip link add veth2-3 type veth peer name veth3-2

echo "assign each side of the veth to one of the namespaces"
ip link set veth1-2 netns ns1
ip link set veth2-1 netns ns2

ip link set veth2-3 netns ns2
ip link set veth3-2 netns ns3

echo "create ip addresses on each side"
ip netns exec ns1 ip addr add 1.0.0.1 dev veth1-2
ip netns exec ns2 ip addr add 1.0.0.2 dev veth2-1

ip netns exec ns2 ip addr add 1.0.0.2 dev veth2-3
ip netns exec ns3 ip addr add 1.0.0.3 dev veth3-2

echo "bring the interfaces up"
ip netns exec ns1 ip link set dev veth1-2 up
ip netns exec ns2 ip link set dev veth2-1 up

ip netns exec ns2 ip link set dev veth2-3 up
ip netns exec ns3 ip link set dev veth3-2 up

echo "create routing table entries on each side"
ip netns exec ns1 ip route add 1.0.0.2 dev veth1-2
ip netns exec ns2 ip route add 1.0.0.1 dev veth2-1

ip netns exec ns2 ip route add 1.0.0.3 dev veth2-3
ip netns exec ns3 ip route add 1.0.0.2 dev veth3-2

echo "add some connection quality issues"
ip netns exec ns1 tc qdisc add dev veth1-2 root netem delay 100ms 20ms distribution normal
ip netns exec ns2 tc qdisc add dev veth2-1 root netem delay 100ms 20ms distribution normal

ip netns exec ns2 tc qdisc add dev veth2-3 root netem delay 100ms 20ms distribution normal
ip netns exec ns3 tc qdisc add dev veth3-2 root netem delay 100ms 20ms distribution normal
