---
author: "Samy Fodil"
title: "Overview of HTTP Request Handling"
date: "2023-03-20"
tags: ["concepts","taubyte"]
---

If you've read [Ping: Your First Serverless Function]({{< ref "ping-pong" >}}), you might have had questions about what's going on under the hood. In this article, we will explore the journey of an HTTP request within the world of Taubyte, focusing on the unique features such as the "Seer," "Substrate," "TNS," and "Hoarder" protocols.

![rest-func-tb](../images/rest-func-on-taubyte.png)

## DNS Query and Seer Protocol

The process starts with a DNS query to resolve the domain name (e.g., weather-api.taubyte.com) into an IP address. The DNS query encounters a node implementing the "Seer" protocol. This protocol is responsible for providing IP addresses of suitable Taubyte nodes to handle the request based on factors such as load, latency, and geographic location. These nodes implement the "Substrate" protocol.

## HTTP Request to Substrate Nodes

With the IP addresses from the Seer, the HTTP request targets one of the "Substrate" nodes. The request carries information such as the HTTP method (e.g., GET, POST), headers (e.g., Content-Type, Authorization), and the desired API endpoint (e.g., `/weather`).

## Substrate Protocol and TNS Lookup

Upon receiving the HTTP request, the "Substrate" node performs a lookup by consulting a node implementing the "TNS (Taubyte Name Service)" protocol. TNS is responsible for mapping human-readable names to machine-readable resources. In this case, TNS provides a resource object containing the function configuration, which includes details such as memory allocation, execution timeout, and a Content ID (CID) of a WebAssembly module. CID is a concept introduced by IPFS (InterPlanetary File System) to uniquely identify content based on its cryptographic hash.

## Fetching the WebAssembly Module

The "Substrate" node fetches the WebAssembly module using its CID. If the module is not in the node's cache, it reaches out to peers, which could be other "Substrate" nodes or nodes implementing the "Hoarder" protocol. The Hoarder protocol ensures a minimum number of replicas for each asset in the Taubyte network, providing redundancy, fault tolerance, and faster access times.

## Function Execution

The "Substrate" node loads the WebAssembly code and its dependencies, such as libraries or external data sources, into the execution environment. It then executes the function, passing the necessary input parameters, to retrieve the desired data.

## Response Generation

The function generates a response, typically including an HTTP status code (e.g., 200 OK, 404 Not Found), headers (e.g., Content-Type, Cache-Control), and a body containing the result in a format such as JSON or XML.

## Returning the Result

The "Substrate" node sends the generated response back to the app, which processes and displays the data to the user. Taubyte takes care of scaling, resource deallocation, and other management tasks automatically, ensuring optimal performance and resource utilization.

## Conclusion

This article has provided an in-depth look at the processes and components involved in handling an HTTP request within Taubyte's decentralized cloud computing platform. By understanding the unique features and interactions between the Seer, Substrate, TNS, and Hoarder protocols, software developers can appreciate the innovation and decentralized nature of Taubyte. With its advanced architecture, Taubyte offers a powerful alternative to traditional cloud computing solutions, fostering efficiency, scalability, and security in a decentralized environment.
