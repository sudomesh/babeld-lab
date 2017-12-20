# Sudo Mesh Service Setup Guide 

This guide is intended to help mesh node operators to:
* decide what service might work well on a mesh network
* implement their service
* make their service accessible on the mesh (and the Internet?)
* maintain their service
* teach others to set up services

## So you want to put a service on the mesh...
Maybe you just became a node on a mesh network, or maybe you'd like to learn more about how services work on a mesh. Whatever the case, you probably have a great idea for a service that could run on a distributed network. However, the first step is learn the concepts of meshing by building your own node.

## build a mesh node
To host a service on a mesh, you must first be a node on said mesh. A mesh node can be almost any laptop, server, raspberry pi, or home router. To be part of a mesh, a device must be capable of three tasks:
* running a mesh routing protocol (e.g. babel-d)
* obtaining a mesh IP address (either statically from a server or via a distributed method, such mDNS)
* digging a tunnel to the exit node (assuming that you'd like to connect to the world outside the mesh, or have only virtual connections to the mesh)

### running babeld 
babeld is how mesh nodes say hi, talk to one another, tell eachother about their neighbors. A great place to start learning about babel-d is our [babeld-lab](https://github.com/sdomesh/babeld-lab).

### getting a mesh IP
Currently sudomesh uses a centralized database to manage IP address assignment, ensuring that there are no duplicate IPs handed out. This is a temporary solution until a distributed one is developed. Use [makenode](https://github.com/sudomesh/makenode) to get a sudomesh IP or figure out how to deploy your own [meshnode database](https://github.com/sudomesh/meshnode-database).

### digging a tunnel
Even if you do not have a physical connection to the mesh, you can still be part of the mesh. By digging a tunnel through a VPN to the exit node, your mesh node can be connected to every other mesh node. It also functions as a way to connect to the broader internet. sudomesh uses the [tunneldigger](https://github.com/wlanslovenija/tunneldigger) developed by wlanslovenija. Check out our [tunneldigger-lab](https://github.com/sudomesh/tunneldigger-lab) to get started.

