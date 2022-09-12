---
author: "Samy Fodil"
title: "Create a project on Taubyte"
date: "2022-09-01"
tags: ["101","taubyte"]
---

Before you dive into the step-by-step, let's cover some basics. 

# Basics

## Git
[Git](https://git-scm.com/) is a distributed version control system designed to handle everything from small to very large projects with speed and efficiency. Yes, it is decentralized though it pre-dates Web 3.0.

If you're new to Git, check those resources out:
 - [Introduction to Git](https://drupalize.me/series/introduction-git)
 - [Try Git](https://trygit.js.org/)
 - [Git Quest](https://gitcoin.co/quests/186/git-essentials)
 - [Learn Git Branching](https://learngitbranching.js.org/)

## Source of Truth
Unlike any other Web2 (or Web2-like) platform that keeps the project saved in databases, Taubyte has neither control nor ownership of your project. Your project resides in your repository, and what the Taubyte network stores are references to it.

Every project is defined by two repositories:
 - The **Configuration Repository** is a collection of [YAML](https://yaml.org) files that define your project resources.
 - The **Inline Code Repository** is a companion repository that facilitates inline code.

Those repositories are the source of Truth for your project.

### A multiverse of Truths!
A repository does not have one defined state, but rather has a state for a specific commit (or branch). Taubyte is built to take advantage of that so you can deploy different versions of your projects on different parts of the network. Most of the nodes in the network will look at `master` (or `main`) branch as their version of the truth.

## Access control
As mentioned before, you have full control of your project. To grant or revoke access you just need to do so on your repositories.


# Taubyte Web Console (console)
The Taubyte Web Console is a powerful tool that you can use to build your project on Taubyte.

## You're in control
Taubyte console is a dApp and therefore it is trustless and built so you keep control and ownership. 
When you login, we will discuss this next, it will clone your project repositories inside an in-browser virtual file system. Every operation you do happens locally until you push.
![console-git-repos](../images/console-git-repos.png)

