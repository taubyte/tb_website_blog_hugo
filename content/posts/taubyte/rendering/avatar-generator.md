---
author: "Samy Fodil"
title: "Avatar generator function"
date: "2022-09-23"
tags: ["rendering","taubyte"]
ShowToc: true
TocOpen: false
ShowBreadCrumbs: true
---


After contemplating how complex the implementation of an avatar generator is on one of the most popular Web 2.0 Clouds, I just had to prove how simple it can be on Taubyte (The Web 3.0 Cloud). Besides finding a nice package that generates the avatars, it took me less than 5min to have it live on `avatar.examples.tau.link`:

{{< highlight url >}}
https://avatar.examples.tau.link/goavatar?gender=male&username=fodil.samy
{{< /highlight >}}

Will generate:
![generated-avatar](https://avatar.examples.tau.link/goavatar?gender=male&username=fodil.samy)


Steps to do the same below.

# Getting started
If this is your first time using Taubyte, head to [this article]({{< ref "ping-pong" >}}) for a Quickstart. Otherwise, go ahead and create a new project followed by a new application.

# Domain
Make sure you have a domain attached to the application you've just created. Refer to "[Ping: Your First Serverless Function]({{< ref "ping-pong" >}}#create-a-domain)" if you're not sure how.

![create-domain](../images/create-domain.png)


# Function
Now that we have everything set up, let's get to the function itself. If in doubt fall back to "[Ping: Your First Serverless Function]({{< ref "ping-pong" >}}#create-a-domain)".

![goavatar-function](../images/goavatar-function.png)



## Code
We're going to use the "[github.com/o1egl/govatar](https://github.com/o1egl/govatar)" package to generate the avatars. The exported method `GenerateForUsername` takes two arguments: a gender and a username. Diggin into it, I noticed that the generated image depends on the username's hashed into  an integer, which means:
 - The same username will result in the same avatar
 - A random/changing string will result in the same on the avatar side. This is why you'll see me using a simple `time.Now()` call to emulate the behavior.


First, declare your package. It does not have to be `lib` but we'll call it a "best practice" as we might make it a naming convention for inline functions later.
{{< highlight go >}}
package lib
{{< /highlight >}}


Import all the needed packages:
{{< highlight go >}}
import (
	"bytes"
	"strings"
	"time"

	"bitbucket.org/taubyte/go-sdk/event"

	"tinygo.org/x/drivers/image/png"

	"github.com/o1egl/govatar"
)
{{< /highlight >}}

Then, declare your function. Make sure the name in `//export` matches the serverless function's entry point.
{{< highlight go >}}
//export avatar
func avatarGo(e event.Event) uint32
{{< /highlight >}}

The function will be triggered by an HTTP event, let's extract it:
{{< highlight go >}}
	h, err := e.HTTP()
	if err != nil {
		return 1
	}
{{< /highlight >}}

Our request will look like this:
{{< highlight url >}}
https://avatar.your.domain.tld/goavatar?gender=<gender>&username=<username>
{{< /highlight >}}

Use `Query().Get()` to extract `gender`. We will generate a gender based on time if none is provided.
{{< highlight go >}}
	gender, _ := h.Query().Get("gender")
	if gender == "" {
		if time.Now().UnixNano()%2 == 0 {
			gender = "female"
		} else {
			gender = "male"
		}
	}
{{< /highlight >}}

Do the same for `username`. We'll use the current time as username is none provided.
{{< highlight go >}}
	username, _ := h.Query().Get("username")
	if username == "" {
		username = time.Now().String()
	}

	var _gender govatar.Gender
	switch strings.ToLower(gender) {
	case "male", "m":
		_gender = govatar.MALE
	case "female", "f":
		_gender = govatar.FEMALE
	}

{{< /highlight >}}


Now, let's now call the `GenerateForUsername`. It will return an [`image.Image`](https://pkg.go.dev/image#Image).
{{< highlight go >}}
	img, err := govatar.GenerateForUsername(_gender, username)
	if err != nil {
		h.Write([]byte("Generate failed with " + err.Error()))
		return 1
	}
{{< /highlight >}}

Finally, we convert the image into a PNG that we send to the client.
{{< highlight go >}}
	var b bytes.Buffer

	err = png.Encode(&b, img)
	if err != nil {
		h.Write([]byte("PNG Encoding failed with " + err.Error()))
		return 1
	}

	h.Headers().Set("Content-Type", "image/png")
	h.Write(b.Bytes())

{{< /highlight >}}

# Commit and Push
At this point, everything is happening inside a virtual file system hosting your repo on your browser. To make the network aware of your changes, you need to push them to Github.

![push-btn](../images/push-btn.png)

# Builds
Check that the build for both configuration and the function's code went through.
![builds-page](../images/builds-page.png)

# Test it
Navigate to `https://avatar.your.domain.tld/goavatar` (don't forget to set your username)
![generated-avatar](https://avatar.examples.tau.link/goavatar)

# References
- Code
  - Config https://github.com/taubyte/tb_examples/tree/master/applications/avatar_backend
  - Code https://github.com/taubyte/tb_code_examples/blob/master/avatar_backend/functions/
- [Taubyte Go SDK documentation](https://pkg.go.dev/bitbucket.org/taubyte/go-sdk)
- [github.com/o1egl/govatar](https://github.com/o1egl/govatar)
