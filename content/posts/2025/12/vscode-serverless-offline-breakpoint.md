---
# Title of your post. If not set, filename will be used.
title: "Debugging `serverless-offline` with vscode debugger"
date: 2025-12-31T14:00:15+09:00
draft: false

# Set weigth to 1 to mark this post as sticky post.
weight: 10

# List of authors of the post.
authors:
  - dgkim

# Tags for this post.
tags:
  - "Development"
---

## Problem

When using `vscode` as a IDE and the framework is `serverless-offline`.  
If you try to debug `typescript` code with breakpoint, it may not work properly.

### TL; DR;

Set up `serverless-esbuild` configuration in `serverless.yml`
```yaml
custom:
  esbuild:
    bundle: true
    platform: node
    target: node18
    sourcemap: true          # THIS WILL MAKE THE BREAKPOINTS ON TS FILE WORK
    sourcesContent: true
    keepNames: true
```

### Detailed Configuration

- IDE: `vscode`
- Framework: `serverless`
- Local runtime: `serverless-offline`
  - Run local debug server with
    ```bash
    sls offline
    ```
- Development language: `typescript`
- Build with: `serverless-esbuild`

In normal case, any `node` process can be debugged with vscode with `JavaScript Debug Terminal`. but, when running `sls offline`, it seems the debugger session is attached to the process but the breakpoints are not working.
After several `googling`, there were `try launch.json configuration`, `use SLS_DEBUG` and etc.

And I found that the breakpoint work in files `.esbuild/.build/src/*.js`, and the last magic is to configure `serverless-esbuild`(as seen above)

<hr />

Here is my serverless configration snippet
```yaml
service: my-flea-market-api

frameworkVersion: '3'
plugins:
  - serverless-esbuild
  - serverless-offline
custom:
  esbuild:
    bundle: true
    platform: node
    target: node22
    sourcemap: true          # 핵심
    sourcesContent: true     # 추천(WSL/컨테이너/상대경로 꼬임 방지)
    keepNames: true          # 선택(스택트레이스 가독성)
  serverless-offline:
    httpPort: 3001

functions:
  likeItem:
    handler: src/handlers/likeItem.handler
    events:
      - http:
          path: /items/{slug}/like
          method: post
          cors: true
```