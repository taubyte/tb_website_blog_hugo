---
author: "Samy Fodil"
title: "The story of an HTTP request"
date: "2023-03-20"
tags: ["concepts","taubyte"]
---

I you've read, [Ping: Your First Serverless Function]({{< ref "ping-pong" >}}), you might had questions on what's going on under the hood. Not anymore, let's explore the journey of an HTTP request within the world of Taubyte, focusing on the unique features such as the "Seer," "Substrate," "TNS," and "Hoarder" protocols.

![rest-func-tb](../images/rest-func-on-taubyte.png)


## DNS Query and Seer Protocol
The process starts with a DNS query to resolve the domain name (e.g., weather-api.taubyte.com) into an IP address. The DNS query encounters a node implementing the "Seer" protocol, which provides IP addresses of suitable Taubyte nodes to handle the request. These nodes implement the "Substrate" protocol.

## HTTP Request to Substrate Nodes
With the IP addresses from the Seer, the HTTP request targets one of the "Substrate" nodes, carrying information such as the HTTP method, headers, and the desired API endpoint.

## Substrate Protocol and TNS Consultation
The "Substrate" node consults a node implementing the "TNS (Taubyte Name Service)" protocol to obtain a resource object containing the function configuration and a Content ID (CID) of a WebAssembly module.

## Fetching the WebAssembly Module
The "Substrate" node fetches the WebAssembly module using its CID. If the module is not in the node's cache, it reaches out to peers, which could be other "Substrate" nodes or nodes implementing the "Hoarder" protocol. The Hoarder protocol ensures a minimum number of replicas for each asset in the Taubyte network.

## Function Execution
The "Substrate" node loads the WebAssembly code and its dependencies and executes the function to retrieve the desired data.

## Response Generation
The function generates a response, typically including an HTTP status code, headers, and a body containing the result in a format such as JSON.

## Returning the Result
The "Substrate" node sends the generated response back to the app, which processes and displays the data to the user. Taubyte takes care of scaling, resource deallocation, and other management tasks automatically.

