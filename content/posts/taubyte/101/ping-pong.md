---
author: "Samy Fodil"
title: "Ping: Your First Serverless Function"
date: "2022-09-01"
tags: ["101","taubyte"]
ShowToc: true
TocOpen: false
ShowBreadCrumbs: true
---

In this post, I'll show you how to create your first RESTful Serverless Function.

The first thing to do is to head to [console.taubyte.com](https://console.taubyte.com), log in and create a new project. If it's your first time, follow this quick intro [here]({{< ref "first-project" >}}).


# Create an Application
It is good practice to separate components of your projects. So let's create an application to host our function.

- Navigate to `Applications`
![applications-menu](../images/left-menu-apps.png)

- Click on the ➕ button, this will open a modal to create an application. We'll call it `backend`. Click on ✔️ to validate.
![create-application-backend](../images/create-application-backend.png)

- Click on the application you just created.


# Create a Domain
Because we're creating a RESTful endpoint we will need a DNS domain. If you're not sure what DNS is check [this article](/protos/dns/what-is-dns). If you don't have a domain, start by getting one. If you're not sure where to get one, here's a good article: [The Best Domain Registrars Of 2022](https://www.forbes.com/advisor/business/software/best-domain-registrar/).

- Navigate to the `Domains` tab
![domain-tab-application](../images/domain-tab-application.png)

- Click on the ➕ button, this will open a modal to create an application. We'll call it `ping_domain`. Make sure you type your subdomain in the FQDN field then click on ✔️ to validate.
![create-ping-domain](../images/create-ping-domain.png)
If your domain is `example.com`, you want to type `ping.example.com`


## Domain validation
You need to provide proof that you own the domain in question.

- Click on the link icon next to the domain you've just added
![domain-verification-icon](../images/domain-verification-icon.png)

- The modal provides you with the TXT entry that needs to be added to your DNS zone.
![domain-validation-modal](../images/domain-validation-modal.png)
If you're not sure how to do that, here are guides to the most popular name servers:
  - [AWS Route53](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resource-record-sets-creating.html)
  - [Microsoft Azure](https://docs.microsoft.com/en-us/azure/dns/dns-getstarted-portal)
  - [Google Cloud](https://cloud.google.com/dns/docs/records)
  - [GoDaddy](https://www.godaddy.com/help/add-an-a-record-19238)
  - [Namecheap](https://www.namecheap.com/support/knowledgebase/article.aspx/10357/2254/video-how-do-i-add-a-txt-record-for-my-domain/)
  - [Cloudflare](https://developers.cloudflare.com/dns/manage-dns-records/how-to/create-dns-records/)


In addition to this entry you will need to redirect the DNS requests to this subdomain to the Taubyte network. To do so, add the following entry:

{{< highlight zone >}}
ping IN CNAME nodes.taubyte.com.
{{< /highlight >}}

Once you added the entries, get back to the console and close the modal.

You can continue with the next step as, unlike anything you might have seen before, on Taubyte nodes verify the TXT record individually at run-time.

### Check (optional)
You can use the modal to check for the TXT entry or use one of the many online tools available out there. As a Linux user, I prefer to use `dig`, so that's what I'm going to show you:

- To check the TXT entry you run
{{< highlight shell >}}
$ dig txt entry-provided-by-modal
{{< /highlight >}}
  Example: this blog at the time of writing
{{< highlight shell >}}
$ dig txt qmpkcpkm.blog.taubyte.com

; <<>> DiG 9.16.27-RH <<>> txt qmpkcpkm.blog.taubyte.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 42202
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;qmpkcpkm.blog.taubyte.com.	IN	TXT

;; ANSWER SECTION:
qmpkcpkm.blog.taubyte.com. 60	IN	TXT	"eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZGRyZXNzIjoiNWRzZFcxcHRYdFRwQm9LWlY3bVNkR2Q1WFlvWnV5In0.5Iqzg3N5MzDo9ougpJveKGbzcArSo8TibXrfBMcHDstm9CtGPLymrxzXuX1d1pCs14er0P0hP1BGcLxoRvWZMw"

;; Query time: 20 msec
;; SERVER: 127.0.0.53#53(127.0.0.53)
;; WHEN: Mon Sep 12 12:49:50 CDT 2022
;; MSG SIZE  rcvd: 250
{{< /highlight >}}
  Notice the answer section
{{< highlight shell >}}
;; ANSWER SECTION:
qmpkcpkm.blog.taubyte.com. 60	IN	TXT	"eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZGRyZXNzIjoiNWRzZFcxcHRYdFRwQm9LWlY3bVNkR2Q1WFlvWnV5In0.5Iqzg3N5MzDo9ougpJveKGbzcArSo8TibXrfBMcHDstm9CtGPLymrxzXuX1d1pCs14er0P0hP1BGcLxoRvWZMw"
{{< /highlight >}}

- To check the CNAME entry you run
{{< highlight shell >}}
$ dig ping.your.domain.tld
{{< /highlight >}}
  Example: this blog at the time of writing
{{< highlight shell >}}
$ dig blog.taubyte.com

; <<>> DiG 9.16.27-RH <<>> blog.taubyte.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 36156
;; flags: qr rd ra; QUERY: 1, ANSWER: 3, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;blog.taubyte.com.		IN	A

;; ANSWER SECTION:
blog.taubyte.com.	54	IN	CNAME	nodes.taubyte.com.
nodes.taubyte.com.	60	IN	A	20.9.66.151
nodes.taubyte.com.	60	IN	A	20.231.58.152

;; Query time: 70 msec
;; SERVER: 127.0.0.53#53(127.0.0.53)
;; WHEN: Mon Sep 12 12:55:25 CDT 2022
;; MSG SIZE  rcvd: 97
{{< /highlight >}}
  Notice in the answer section, the first line is the CNAME. The other lines are IPs provided by the network for the best-suited nodes at that time
{{< highlight shell >}}
;; ANSWER SECTION:
blog.taubyte.com.	54	IN	CNAME	nodes.taubyte.com.
nodes.taubyte.com.	60	IN	A	20.9.66.151
nodes.taubyte.com.	60	IN	A	20.231.58.152
{{< /highlight >}}




# Create a function
All those steps led you here, the most interesting part really!
Taubyte functions are WebAssembly modules that are triggered by an event. In this case, the event is an HTTP request.

- First, switch to the `functions` tab
![functions-tab](../images/functions-tab.png)

- Click on the ➕ button.
  - Name it `ping`
  - Select your domain
  - Toggle `Use Inline Code`
  - Select the `ping_pong` template.
  - Finally, Click on ✔️ to create.
![ping-func](../images/ping-func.png)


## The code
We're focusing on [Go](https://go.dev/), as of this article, it's the only language that Taubyte supports.

- The first line of code informs us of the name of the package. Because there's a lot of automation happening under the hood to make inline code possible, we recommend to keep it to `lib`.
{{< highlight go >}}
package lib
{{< /highlight >}}

- Next the Taubyte [Go SDK](https://pkg.go.dev/bitbucket.org/taubyte/go-sdk) is imported. The SDK provides a friendly interface to the ABI provided by the Taubyte Virtual Machine (TVM)
{{< highlight go >}}
import (
    "bitbucket.org/taubyte/go-sdk/event"
)
{{< /highlight >}}

- Next, is the function `ping`. It takes one argument which is the Event that triggered the function.
{{< highlight go >}}
//export ping
func ping(e event.Event) uint32 {
...
}
{{< /highlight >}}
It is important to export the function with `//export` so the TVM can call it.


- Because a function can be triggered by events of different types, you need to check what event it is first.
{{< highlight go >}}
h, err := e.HTTP()
if err != nil {
 return 1
}
{{< /highlight >}}

- Given an HTTP event, we can send a message back to the client. This is done by a simple `Write()` call.
{{< highlight go >}}
h.Write([]byte("PONG"))
{{< /highlight >}}


Full code:
{{< highlight go >}}
package lib

import (
  "bitbucket.org/taubyte/go-sdk/event"
)

//export ping
func ping(e event.Event) uint32 {
  h, err := e.HTTP()
  if err != nil {
   return 1
  }

  h.Write([]byte("PONG"))
  
  return 0
}
{{< /highlight >}}


# Commit and Push
At this point, everything is happening inside a virtual file system hosting your repo on your browser. To make the network aware of your changes you need to push to Github.

- Click on the big green button on the bottom right
![push-btn](../images/push-btn.png)
This will open a modal that will guide you through three pages:
  - **Configuration changes** there you will see all the diffs related to resources. In addition to all the other resources you created, under `Applications` > `ping` > `Functions` you can see your newly created function.

  - **Code changes** there you will see all the diffs related to inline code. Try to spot `ping.go`

  - **Commit message** there you should enter a commit message and click on `Finish` to push.

# Check you repo
Now that you pushed your code, you can check the changes on github. The console has a helper to take you there:
 - Click on your avatar in the top right corner
 - Click on `Project Details`
 - Click on URL of the repo you want to check out

# Builds
Each time you push code to Github, jobs to rebuild code and config are created by the network in response to the event. You can check those build jobs and their status on the Builds page.
![builds-page](../images/builds-page.png)

# Test it
You can either test it from your browser by navigating to `https://ping.your.domain.tld/ping`, or use curl as follow

{{< highlight shell >}}
$ curl https://ping.your.domain.tld/ping
PONG
{{< /highlight >}}

# Challenge
Modify the message, push the code and test it again.

# References
- [Taubyte Go SDK documentation](https://pkg.go.dev/bitbucket.org/taubyte/go-sdk)
