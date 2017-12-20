(this is a work in progress)  

# Welcome to the mesh (0 to 60 m/hr in 3 seconds)  
Q: What's the mesh? And why do we need one?  
A: The mesh is a decentralized network of computers (or nodes). A mesh is useful because there is no single point of failure. If an individual node goes down, the mesh network will still work. Also, because there is no central node that needs to exist for the network to function, the ownership of the network is shared between all the nodes.

Q: What are nodes? And how do I get one?  
A:  In the peoplesopen.net mesh network, nodes are wireless routers (like Western Digital N600s). Normally, these routers are configured to connect a LAN (your local network) to the WAN (the internet) using your ISP's infrastructure. In a mesh configuration, the routers also talk to each other, creating a third network akin to the MAN (municipal area network). This MAN connects nodes that are physically near each other. If you'd like to get a node suitable for working with peoplesopen.net, please get a compatible router and flash it with the appropriate firmware build (see guide below).

Q: Ok, but I want to help out more?  
A: Glad to hear! Continue to the roles section below to see how you can get more involved.   

# roles  
Mesh networks don't happen by themselves, they require a ton of effort and a lot of collaboration. If you would like to help out, there are three general roles that anyone (with the right motivation) can fulfill (and of course, plenty of other form of contribution including legalistics, design, UX, etc).  
 1. Community Organizer and/or Educator  
      Are you a people person? Would you like to help our network expand and provide access to those who need it most? Use your social skills to help get the word out. Talk to neighbors and local businesses about setting up a node in their buildings. Help plan events that raise awarness of the mesh. (events, outreach, press, education)  
 2. Technical Support   
      Do you like scaling tall buildings? Are you a skilled troubleshooter? Help provide day-to-day management and maintenance of the mesh. Assist in the deployment of nodes and roof-mounted antennae! (node deployment, troubleshooting, rooftop mounting)  
 3. Software Engineering   
      Are you a hacker or programmer? Do you know how to use git? Fork our repos, modify some code (or just edit a README), and we'll potentially make you a contributor. If you'd like fulfill this role, continue to the Educational Guides to learn the technical side of mesh networks and how you can contribute to our many dev projects. (firmware development, monitoring tools)  
 
# software engineering/education  
 
The purpose of this page is to help you get started with decentralized networking so that you can ready to help improve our firmware (or build your own!), maintain the/a network and teach others to do the same.
 
# pre-requiste concepts

OSI Model -
Network Interface - 
TCP/IP -
Linux Tools - ip/brctl/ -
Router -
Switch -
 
# educational guides  
If you wish to become involved on a technical level, there are a handful of educational tools that we have developed to help you acquaint yourself with mesh networks and their associated concepts.  
   
 1. (Learn) **Deploy an n-node virtual network ([babeld-lab](https://github.com/sudomesh/babeld-lab))** This will help you learn about (and visualize?) the underlying protocol that controls the flow of information on the mesh. If you want to help troubleshoot potential conflicts in the WAN as the mesh grows, this is the guide for you!  
 2. (Learn) **Dig a tunnel ([tunneldigger-lab](https://github.com/sudomesh/tunneldigger-lab))** Tunnels are dug to connect a nodes in a mesh network with the "big" internet through one or more exit nodes. Also, the tunnels are used to propagate babeld messages to help nodes discover each other. So, in a way, nodes dig tunnels to an exit node to create a VPMS (a virtual private mesh network). The VPMS prevent ip addresses of individual node operators to be exposed on the "big" internet and help individual nodes to mesh with one another even if they are out of range.
 2. (Build) **Create your own physical node ([build firmware guide](https://github.com/sudomesh/sudowrt-firmware), [create a node](https://peoplesopen.net/walkthrough))**  This will help you learn about the deployment of our custom firmware and its associated hardware. If you want to get involved in the deployment and maintenance of indivdual nodes, want to contribute to the improvement of the firmware or hardware, or just want to deploy your own node, this is the guide for you! This process also registers your node with peoplesopen.net .
 2. (Build) **Operate your own mesh network ([operator's manual](https://github.com/sudomesh/sudowrt-firmware/blob/master/operators_manual.md))**. A mesh network is like a garden: it needs the gardener's shade to grow. 
 2. (Build) **Run your own mesh service ([services guide](https://github.com/sudomesh/babeld-lab/blog/master/services_guide.md))**. Just like you can run a server on the "big" internet, you can run a server on a mesh network. The big difference is that you can run your server independently of the "big" internet - even if a connection to the world wide web is lost, local mesh nodes can continue to use your service. 
 3. (Teach) **Help a friend or a neighbor work through this guide and grow the mesh network.** This will help build out the mesh and learn about the point-to-point wireless connections that are the backbone of any true mesh network. If you want to help build out the mesh in your community or help do the same in other communities, this is the guide for you! 
 4. (Improve) **Help the project evolve** by reporting and fixing bugs; suggesting, researching, and developing features; deploying nodes; educating your peers; improving the documentation; organizing workshops and perhaps starting your own mesh network!
 
