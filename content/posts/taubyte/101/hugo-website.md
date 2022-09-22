---
author: "Samy Fodil"
title: "Blog: Get a Hugo-based blog up"
date: "2022-09-21"
tags: ["101","taubyte", "hugo", "blog"]
ShowToc: true
TocOpen: false
ShowBreadCrumbs: true
---

In the world of web content creation, [Hugo](https://gohugo.io/), is, with no doubt, my favorite. If you're not familiar with Hugo or the concept of static website generators, I suggest checking [https://gohugo.io/documentation/](https://gohugo.io/documentation/).


Though is post, I'll show you how to get a blog up and running in less than 10min!


# Login
Head to [console.taubyte.com](https://console.taubyte.com), log in and create a new project. If it's your first time, follow this quick intro [here]({{< ref "first-project" >}}).


# Create an Application
It is good practice to separate components of your projects. So let's create an application to host our function.

- Navigate to `Applications`
![applications-menu](../images/left-menu-apps.png)

- Click on the ➕ button, this will open a modal to create an application. We'll call it `blog`. Click on ✔️ to validate.

- Click on the application you just created.

# Create a Domain
Right now, Taubyte does not generate sub-domains so you'll have to use your own. This section will assume that you either own or know how to get a DNS domain. If not, start by getting one. 

- Navigate to the `Domains` tab
![domain-tab-application](../images/domain-tab-application.png)

- Click on the ➕ button, this will open a modal to create an application. We'll call it `blog_domain`. Make sure you type your subdomain in the FQDN field then click on ✔️ to validate.
![create-ping-domain](../images/create-ping-domain.png)
If your domain is `example.com`, you want to type `blog.example.com`


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


In addition to this entry, you will need to redirect the DNS requests to this subdomain to the Taubyte network. To do so, add the following entry:

{{< highlight zone >}}
blog IN CNAME nodes.taubyte.com.
{{< /highlight >}}

Depending on you're registar, doing so would look like this:
![example-dns-namecheap](../images/example-dns-namecheap.png)


Once you added the entries, get back to the console and close the modal.

You can continue with the next step as, unlike anything you might have seen before, on Taubyte nodes verify the TXT record individually at run-time.

# Create a website
Now that you have your sub-domain setup, you can attach a website to it. But first, let's cover some cool facts:
 - Websites are built into bundles and stored in the network in a distributed fashion (similar to IPFS)
 - No need to use a CDN (Content Delivery Network) as the Taubyte network will always instantiate your website close to the user
 - Unlike a CDN, updates automatically propagate, generally, in less than 3 seconds.


Back to the web console,

- First, switch to the `websites` tab
![websites-tab-webconsole](../images/websites-tab-webconsole.png)

- Click on the ➕ button.
  - Name it `blog`
  - Leave Repository set to `--Generate--`
  - Select your domain `blog_domain`
  - Set path to `/`
  - Finally, Click on ✔️ to create.
![website-create-blog](../images/website-create-blog.png)

Because you did not set a repository, you will get a repository creation assistant. Select `Hugo` and click on `Generate`.
![website-template-hugo](../images/website-template-hugo.png)

Your new website has been created and the repo contains build scripts for a hugo-based website


# Commit and Push
At this point, everything is happening inside a virtual file system hosting your repo on your browser. To make the network aware of the changes you need to push.

- Click on the big green button on the bottom right
![push-btn](../images/push-btn.png)
This will open a modal that will guide you through three pages:
  - **Configuration changes** there you will see all the diffs related to resources. In addition to all the other resources you created, under `Applications` > `blog` > `Websites` you can see your newly created function.

  - **Commit message** there you should enter a commit message and click on `Finish` to push.

{{< highlight text >}}
You will not see changes in the newly created website repository as those were pushed by the assistant earlier during creation.
{{< /highlight >}}


# Clone your website repo
Now that we have our config set, let's focus on the website itself. 
 - To open the created repository in Github click on the link icon. *Skip to the next section if you know how to clone a Github repo.*
![open-website-repo](../images/open-website-repo.png)

 - On the Github page, copy the clone URI. My favorite is SSH, so we'll go ahead and copy that.
![get-website-clone-uri](../images/get-website-clone-uri.png)

 - Assuming that you have your ssh keys set up correctly, let's clone the repo. *If you're not sure about the ssh keys, read [this](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent).*
{{< highlight shell >}}
$ git clone git@github.com:taubyte/tb_website_hugo.git
Cloning into 'tb_website_hugo'...
remote: Enumerating objects: 5, done.
remote: Counting objects: 100% (5/5), done.
remote: Compressing objects: 100% (3/3), done.
remote: Total 5 (delta 0), reused 5 (delta 0), pack-reused 0
Receiving objects: 100% (5/5), done.
{{< /highlight >}}


 - Create a hugo site
{{< highlight shell >}}
$ npx hugo-extended new site --force tb_website_hugo
Congratulations! Your new Hugo site is created in /tmp/tb_website_hugo.

Just a few more steps and you're ready to go:

1. Download a theme into the same-named folder.
   Choose a theme from https://themes.gohugo.io/ or
   create your own with the "hugo new theme <THEMENAME>" command.
2. Perhaps you want to add some content. You can add single files
   with "hugo new <SECTIONNAME>/<FILENAME>.<FORMAT>".
3. Start the built-in live server via "hugo server".

Visit https://gohugo.io/ for quickstart guide and full documentation.
{{< /highlight >}}
Note that if you have hugo already installed, you can just run
{{< highlight shell >}}
$ hugo new site --force tb_website_hugo
{{< /highlight >}}



 - Change directory to the website repository
{{< highlight shell >}}
$ cd tb_website_hugo
{{< /highlight >}}


 - We're going to use `github.com/nunocoracao/blowfish` as theme. Start by cloning it as a sub module
{{< highlight shell >}}
$ git submodule add -b main https://github.com/nunocoracao/blowfish.git themes/blowfish
Cloning into '/tmp/tb_website_hugo/themes/blowfish'...
remote: Enumerating objects: 5296, done.
remote: Counting objects: 100% (315/315), done.
remote: Compressing objects: 100% (187/187), done.
remote: Total 5296 (delta 161), reused 216 (delta 99), pack-reused 4981
Receiving objects: 100% (5296/5296), 60.89 MiB | 4.08 MiB/s, done.
Resolving deltas: 100% (2691/2691), done.
{{< /highlight >}}
 
  - Open `config.toml` with your favorite IDE and make it look like:
{{< highlight toml >}}
baseURL = 'https://your.blog.domain.tld/'
languageCode = 'en-us'
title = 'Blog running on Taubyte'
theme = "blowfish"
{{< /highlight >}}


  - Serve your website locally
{{< highlight shell >}}
$ npx hugo-extended server
Start building sites … 
hugo v0.103.1-b665f1e8f16bf043b9d3c087a60866159d71b48d+extended linux/amd64 BuildDate=2022-09-18T13:19:01Z VendorInfo=gohugoio

                   | EN  
-------------------+-----
  Pages            |  7  
  Paginator pages  |  0  
  Non-page files   |  0  
  Static files     |  9  
  Processed images |  0  
  Aliases          |  0  
  Sitemaps         |  1  
  Cleaned          |  0  

Built in 27 ms
Watching for changes in /tmp/tb_website_hugo/{archetypes,content,data,layouts,static,themes}
Watching for config changes in /tmp/tb_website_hugo/config.toml, /tmp/tb_website_hugo/themes/blowfish/config.toml, /tmp/tb_website_hugo/themes/blowfish/config/_default, /tmp/tb_website_hugo/go.mod
Environment: "development"
Serving pages from memory
Running in Fast Render Mode. For full rebuilds on change: hugo server --disableFastRender
Web Server is available at http://localhost:1313/ (bind address 127.0.0.1)
Press Ctrl+C to stop
{{< /highlight >}}

  - Navigate to `http://localhost:1313/` to access the website locally.

  - Feel free to edit the content as you see fit


# Push
All you have to do now is push your code!

 - Commit
{{< highlight shell >}}
$ git add .
$ git commit -m 'My first hugo website'
[master 14517b8] My first hugo website
 4 files changed, 15 insertions(+)
 create mode 100644 .gitmodules
 create mode 100644 archetypes/default.md
 create mode 100644 config.toml
 create mode 160000 themes/blowfish
{{< /highlight >}}

 - And Push
{{< highlight shell >}}
$ git push
Enumerating objects: 8, done.
Counting objects: 100% (8/8), done.
Delta compression using up to 8 threads
Compressing objects: 100% (5/5), done.
Writing objects: 100% (7/7), 757 bytes | 378.00 KiB/s, done.
Total 7 (delta 0), reused 0 (delta 0), pack-reused 0
To github.com:taubyte/tb_website_hugo.git
   f7a43c1..14517b8  master -> master
{{< /highlight >}}


# Builds
Each time you push code to Github, jobs to rebuild code and config are created by the network in response to the event. You can check those build jobs and their status on the Builds page.
![builds-page](../images/builds-page.png)

For your website, you should see something like
![website-build-log](../images/website-build-log.png)

You can download the built website as well by clicking on the icon at the far right
![website-build-download](../images/website-build-download.png)

# Access your website
Open your browser and check out your new blog/website!
![website-in-browser](../images/website-in-browser.png)


# References
 - [Blowfish's Getting Started](https://nunocoracao.github.io/blowfish/docs/getting-started/)