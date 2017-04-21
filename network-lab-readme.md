# Network lab
This script creates a set of network namespaces, linked by virtual eth connections. It is entirely driven by a JSON network graph configuration format. Additionally, it uses the [tc netem](http://man7.org/linux/man-pages/man8/tc-netem.8.html) traffic shaper to simulate various kinds of faulty connections, packet loss, and latency on the links. This tool was created to experiment with and test routing protocols, but it could have many other uses.

## Dependencies
Your system must have network namespace support. For example, Ubuntu 16.04 will work. Also, [jq](https://stedolan.github.io/jq/) must be installed.

## Usage
Most operations on network namespaces require `sudo`, and the network-lab sets some handy aliases for working with network namespaces. So the preferred way to start it currently is like this:

```bash
sudo -i
source ./network-lab.sh example-network.json
```

To do operations inside the namespaces, you can now use the aliases defined by the script:

```bash
n<node name> <your command>
```
for example
```bash
$ n1 ip route
1.0.0.2 dev veth-1-2  scope link 
1.0.0.3 via 1.0.0.2 dev veth-1-2 
```

## Configuration
Network lab has a JSON configuration format:

```json
{
  "nodes": {
    "1": {
        "ip": "1.0.0.1",
        "startup": ["ip route add 1.0.0.2 dev veth-1-2",
                    "ip route add 1.0.0.3 via 1.0.0.2",
                    "sysctl -w net.ipv4.ip_forward=1"]
    },
    "2": {
        "ip": "1.0.0.2",
        "startup": ["ip route add 1.0.0.1 dev veth-2-1",
                    "ip route add 1.0.0.3 dev veth-2-3",
                    "sysctl -w net.ipv4.ip_forward=1"]
    },
    "3": {
        "ip": "1.0.0.3",
        "startup": ["ip route add 1.0.0.2 dev veth-3-2",
                    "ip route add 1.0.0.1 via 1.0.0.2",
                    "sysctl -w net.ipv4.ip_forward=1"]
    }
  },
  "edges": [
    {
      "nodes": ["1", "2"],
      "->": "delay 10ms 20ms distribution normal",
      "<-": "delay 500ms 20ms distribution normal"
    },
    {
      "nodes": ["2", "3"],
      "->": "delay 10ms 20ms distribution normal",
      "<-": "delay 500ms 20ms distribution normal"
    }
  ]
}

```

The `nodes` object has all the nodes, indexed by name.
- The `ip` property will be set as the node's IP addres
- The `startup` property contains an array of commands that will be executed in the node's network namespace once everything is set up.

The `edges` object contains an array of edges.
- The `nodes` array contains the node names of the 2 sides of the edge.
- The `->` and `<-` properties contain arguments to be given to the [tc netem](http://man7.org/linux/man-pages/man8/tc-netem.8.html) command to degrade the connection from the left node to the right node and vice vera.