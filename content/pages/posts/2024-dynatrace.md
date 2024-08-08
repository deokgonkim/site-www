---
# Title of your post. If not set, filename will be used.
title: "Tested Dynatrace"
date: 2024-08-08T10:30:07+09:00
draft: false

# Set weigth to 1 to mark this post as sticky post.
weight: 10

# List of authors of the post.
authors:
  - dgkim

# Tags for this post.
tags:
  - "APM"

# Set how many table of contents levels to be showed on page.
geekblogToC: 3

# Add an anchor link to headlines.
geekblogAnchor: true
---

## Behind story

I have been using APM since 2006. the first was Jennifer (for java). and Scouter (similar to jennifer x-view)

And the year 2020, I meet elastic apm (half setup). I finished the setup from Python django monitoring, to Vue RUM(with sourcemap).

In the year 2023, I tried Sentry for the first time. It seems new and is specialized for error tracking. I have set up for `NestJS`(backend), `React`(web frontend) and `ReactNative`. It was not that bad with error tracking.

But I found sentry is lacking in two aspects. (sorry sentry)

1. Not all error is traced. (It's pricing method is based on error count)
2. (this is same pain point too.) Not all transaction is traced.

What I found useful in Sentry

1. It provides `session replay` : some glimpse of what user did on web page.
2. The errors can be marked(either resolved or assign to some one) or deleted.

## Let's try new APMs

Searched trending APMs. I found `Dynatrace`, `Data Dog`, `New Relic`, ...
I have searched installation method and asked ex-colleagues what they are using. some says they uses data dog.
I've experienced data dog, and I think it can be pricy for very beginning startups.

Dynatrace is advertising with `Award(?) winning(?)`. and it is automaticaly traced compared to `New Relic` (asked OpenAI or gemini)

I have installed `ElasticAPM` and `Dynatrace` along with `Sentry`.

## Try Dynatrace

Dynatrace installation is basically installing an `Agent` binary on `Server` OS.

----

I've tried installing on `EC2` that runs `Docker compose` and two container and `Nginx`
Than it shows some `server matrics` and the traces as `access log` style(?).

### Backend part

And I need to install on a container image that will be deployed on `AWS Fargate`
There is a way to accomplish this using `Dockerfile` command like follows.

```
# https://docs.dynatrace.com/docs/setup-and-configuration/setup-on-container-platforms/docker/set-up-oneagent-on-containers-for-application-only-monitoring
# You need to `docker login` on your host or CI/CD environment
COPY --from=abc00000.live.dynatrace.com/linux/oneagent-codemodules:nodejs / /
ENV LD_PRELOAD /opt/dynatrace/oneagent/agent/lib64/liboneagentproc.so
```
So, this means unlike `Sentry` and `ElasticAPM` it will hook binaries not the native language that I am working with like `JavaScript` or `Python`

### Frontend part

And I will deploy `React` web application on `AWS CloudFront`, so I can't install Agent on web tier too.
There is also a way to install `RUM` agent on web source code.

```
<!-- dynatrace tracing -->
<script type="text/javascript" src="https://js-cdn.dynatrace.com/jstag/123456789ee/bf12345yst/12f34567d890a123_complete.js" crossorigin="anonymous"></script>
```

And can capture my errors to APM using following code.

```javascript
// dynatrace error reporting
if ('dtrum' in window) {
  const dtrum = (window as any).dtrum;
  dtrum.reportError(error);
}
```

Tracing user

```javascript
// dynatrace set user
if ('dtrum' in window) {
  const dtrum = (window as any).dtrum;
  dtrum.identifyUser(response?.data?.email);
}
```

## Conclusion

1. Dynatrace is promising observabilities, but not in a way that I want.
    - Hard to find Errors/Exceptions (or just I didn't found a way that shows what I want)
    - It shows tracing from application tier to infrastructure layer. but What I am now care about is almost all about application tier.
2. It is hard to use it to custom tracing or error tracking.
    - it is basically not providing a sdk, It seems provides but not in a way that I am familiar with or used to
