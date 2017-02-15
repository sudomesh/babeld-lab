# babeld-lab
virtual network lab for babeld experiments

The purpose of this project is to setup a virtual babel mesh for educational and testing purposes purposes. 

# requirements
1. a linux of sorts
2. [babeld](https://github.com/jech/babeld)
3. [wireshark](https://wireshark.org)
4. access to tools [ip](http://man7.org/linux/man-pages/man8/ip.8.html) and [brctl](https://linux.die.net/man/8/brctl) (in bridge-tools) 

# building a virtual two node babel mesh
To build an experimental setup that connects (virtual) babel nodes without having to mess around with physical hardware, various techniques can be used. One of them is using linux's veth, brctr, and ip to create virtual network interfaces and bridges and (optionally) isolate them using namespaces. 

Docker is using the same tools under the hood to configure network interfaces. Docker provides much more functionality, but for our intended purposes, we don't need to create containers to demonstrate how babeld works.

# step 1: add interfaces
this adds interfaces

```
sudo sh babeld-lab add
```
verify that ```ip addr``` now contains br-babel and veth-p0/p1.
also verify that ```sudo ip netns exec n0 ip addr``` contains veth-n0 and ```sudo ip netns exec n1 ip addr``` contains veth-n0. The state of all interfaces should be down.

# step 2: turn interfaces on
```
sudo sh babeld-lab up
```
verify that the ```ip addr``` cmds of step 1 now indicate that the interfaces are up.

# step 3: start babeld's
```
sudo sh babeld-lab start
```
verify that ```sudo ip netns exec n0 ip route``` contains something like:
```
170.30.101.2 via 170.30.101.2 dev veth-n0  proto babel onlink
``` 
and that the ```sudo ip netns exec n1 ip route``` contains something like:
```
170.30.100.2 via 170.30.100.2 dev veth-n1  proto babel onlink 
```

# step 4: monitor babel toggle bridge
start wireshark and select br-babel interface: you should see babel hello and babel ihu (I hear you) messages going back and forth.

When disabling the bridge (similar to unplugging nodes from a network switch), using something like ```sudo sh babeld-lab.sh down_bridge```, the routing tables of n0 and n1 network namespaces should clear out, and traffic should stop.

Enabling using ```sudo sh babeld-lab.sh up_bridge``` should restart the network.

```

# step 5: stop and delete the network 
After doing the experiments, stop babeld ```sudo ./babeld-lab.sh stop```, stop the interfaces/bridge and delete the virtual network interfaces ```sudo sh babeld-lab.sh down```, delete the network interfaces/bridge ```sudo ./babeld-lab delete```


