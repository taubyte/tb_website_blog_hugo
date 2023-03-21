---
author: "Samy Fodil"
title: "Under the Hood: Creating Projects on Taubyte-based Clouds"
date: "2023-03-20"
tags: ["concepts","taubyte"]
---



Taubyte is a decentralized open-source cloud computing platform that leverages the power of WebAssembly for efficient and secure serverless computing. Its unique features and benefits set it apart from traditional platforms. In this blog post, we'll delve into the technical aspects of what happens under the hood when you create a project on a Taubyte-based cloud. This article aims to provide a detailed explanation tailored for software developers to understand the inner workings of this innovative platform.

## The Process

![new-proj-tb](../images/new-prj-taubyte.png)

### 1. Creating repositories
The foundation of a Taubyte project consists of two repositories:

   a. *Configuration Repository*: This repository stores YAML files that define your project resources, including functions, data, and other required components.

   b. *Inline Code Repository*: This companion repository hosts your code and facilitates inline code execution.

These repositories are typically created using tools such as the Taubyte Web Console or Taubyte CLI (tau), but can also be created manually.

### 2. Generating and encrypting deployment keys
For each repository, the user generates a deployment key using the Taubyte Web Console or tau CLI. The deployment key is added to the repository and then encrypted using a selected vault public key. This encryption process generates an encrypted key and a Zero-Knowledge (ZK) proof. The vault public key is chosen through a process detailed in step 4.

### 3. Generating and encrypting secrets and webhooks
The user generates a secret and adds a webhook to each repository. This webhook is secured with the generated secret. Similar to the deployment key, the secret is encrypted using the chosen vault public key, generating an encrypted version of the secret and an associated ZK proof.

### 4. Selecting a vault public key
A crucial aspect of the project creation process is selecting a vault public key for encrypting deployment keys and secrets. Vault nodes in the Taubyte network store encrypted keys and secrets, along with their ZK proofs, and play a role in project registration. Users choose a vault node based on factors such as reputation, geographic location, or available resources. Once a vault node is selected, its public key is used to encrypt the deployment keys and secrets generated in steps 2 and 3.

### 5. Registering the project with a vault node
After creating both repositories, generating and encrypting deployment keys and secrets, and obtaining their respective ZK proofs, the user sends a request to a vault node to register the project. The vault node validates the keys, ZK proofs, and user ownership of the repositories. If all these checks pass, the project is added to the network.

The Taubyte platform uses the repositories as the source of truth for each project, allowing for efficient and secure code execution. By specifying particular branches or commits in their repository, users can deploy different versions of their projects on different parts of the network.

## Conclusion
Through this exploration of the intricate processes and components involved in creating and deploying projects on a Taubyte-based cloud, we hope the reader gains an appreciation for the innovation and unique decentralization aspects of the platform. By understanding Taubyte's technical details, software developers can harness the full potential of this decentralized cloud computing solution. Taubyte offers a refreshing alternative to traditional cloud computing platforms, driving innovation, efficiency, and security in a decentralized manner.
