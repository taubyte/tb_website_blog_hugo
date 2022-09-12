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
![console-git-repos](../images/console-git-repos.svg)

## Login
Taubyte does not have a concept of login per se. In the case of the web console, you're logging into your git account. This process allows the console instance in your browser to acquire a token that will allow different operations like cloning, pushing, creating repositories, etc.

{{< highlight text >}}
The token is only stored in your browser and nowhere else.
{{< /highlight >}}



# Let's get started
Now that you have some basic understanding of those important concepts that make Taubyte uniquely suited for Web 3.0, we can go ahead and get your first project created!

## Web Console
Taubyte web console is a dApp and can be accessed from diffrent places. The most convenient at the  time of writing this article is https://console.taubyte.com

{{< highlight text >}}
Go ahead and navigate to https://console.taubyte.com
{{< /highlight >}}


## Login
Before we can use the console we need to acquire access to git.
 - On the login page, type and email you want us to use for communication (notifications about builds, deployments, etc.).
 - Then click on the git provider you want to use. Example: github.

 This should take you to the project page. The page might be slow to load all your projects as it will fetch details from your git repositories. *Remember, Taubyte does not store much information about your projects*

## Create a project
As described earlier, creating a project is 99% git operations:
 - From your browser [frontend]:
   - Creating inline code and configuration repositories
   - Populating the repositories with an initial structure
 - Through a network node [backend]: 
   - Registering the repositories on the Taubyte network

To make this happen:
 - Click on the ➕ button
![create-project-btn](../images/create-project-btn.png)
 - On the modal, name your project. *Name must abide by variable name restrictions and be unique in your git space*
