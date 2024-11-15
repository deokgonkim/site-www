---
# Title of your post. If not set, filename will be used.
title: "2024 Nov Cloud Project"
date: 2024-11-16T05:57:49+09:00
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

## Cloud Native Development in Nov 2024

- What I first wanted : I want to use `Telegram` and `WhatsApp` as order notification channel

### Set up the first project

- Originally, I used to use plain Lambda function. This time I will try `express`(https://expressjs.com/) + `serverless` lambda
  - `serverless` yaml : I uses `httpApi` integration
    ```yaml
    functions:
      api:
        handler: src/index.handler
        events:
          - httpApi: '*'
    ```
  - index.ts snippet
    ```javascript
    const express = require("express");
    const serverless = require("serverless-http");

    const app = express();

    app.use(express.json());
    app.use(express.urlencoded({ extended: true }));

    app.use('/telegram', require('./telegram/route')); // Use the routes
    app.use('/twilio', require('./twilio/route')); // Use the routes

    // module.exports.handler = serverless(app);
    module.exports = {
      handler: serverless(app),
      app,
    }
    ```

- Set up the `React` frontend
  - Usually, the react project is single git project. This time, I tried to bear two project in one git project
  - I created react app using usual `create-react-app`
  - I setup github actions script to build react app
    ```yaml
    name: build-app
    description: Build app
    inputs:
      app-folder:
        description: Folder containing react app to be built
        required: true

    runs:
      using: "composite"
      steps:
        - name: Pre-build
          # should specify working-directory, shell for every step (in composite run)
          working-directory: ${{ inputs.app-folder }}
          shell: bash
          run: npm ci
        - name: "Build app"
          working-directory: ${{ inputs.app-folder }}
          shell: bash
          run: |
            DISABLE_ESLINT_PLUGIN=true npm run build
    ```
  - and the deploy step will copy built artifacts from the build step to the cloudfront
    ```yaml
    jobs:
      build-guest:
        runs-on: ubuntu-latest
        environment: aws
        steps:
          - name: Checkout
            uses: actions/checkout@v4

          - name: "Build guest app"
            uses: "./.github/actions/build-app"
            with:
              app-folder: apps/guest

          # here upload built artififact
          - name: Upload build artifact
            uses: actions/upload-artifact@v3
            with:
              name: guest-app-build
              path: apps/guest/build

      deploy:
        needs:
          - build-guest
        runs-on: ubuntu-latest
        environment: aws
        steps:
          - name: Checkout
            uses: actions/checkout@v4

          # here download the artifacts built.
          - name: Download guest app build artifact
            uses: actions/download-artifact@v3
            with:
              name: guest-app-build
              path: public/guest

      # the publish to cloudfront goes here
    ```

### The telegram and whatsapp thing

- The `telegram bot` will work like a communication channel.
  - The user can talk/chat to a bot using known bot ID or `The telegram URL` for the bot.
  - The telegram URL is in this form `https://t.me/username` or `https://t.me/some_bot`
  - To send a telegram message, I use `node-telegram-bot-api` and can send message with `token` credentials
    ```typescript
    import TelegramBot from 'node-telegram-bot-api';

    const token = process.env.TELEGRAM_BOT_TOKEN || 'no-token-configured';

    export const sendMessage = async (chatId: number, text: string) => {
        const bot = new TelegramBot(token, {
            polling: false,
        });

        return bot.sendMessage(chatId, text);
    }

    ```
  - To receive a telegram message, We should register callback url.
    ```bash
    export TELEGRAM_WEBHOOK_URL=${API_BASE_URL}/telegram/

    curl -X POST https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/setWebhook?url=${TELEGRAM_WEBHOOK_URL}
    ```
- The `WhatsApp Business API` can be used to send a notification message to. But this requires some business information things.. So, I used `twilio` API to test some.
  - The user can talk/chat to a number(business owner number). and also provides `The Whatapp URL` for that number.
  - The whatsapp URL is in this form `https://wa.me/+82100000000`
  - To send a whatsapp message, I use `twilio` api, and twilio provides `accountSid` and `authToken`
    ```typescript
    import { Twilio } from "twilio";

    const accountSid = process.env.TWILIO_ACCOUNT_SID;
    const authToken = process.env.TWILIO_AUTH_TOKEN;

    const client = new Twilio(accountSid, authToken);

    export const sendMessage = async (from: string, to: string, message: string) => {
        return client.messages
            .create({
                body: message,
                from,
                to,
            })
            .then((message) => {
                console.log(message.sid);
                return message;
            });
    };
    ```
  - To receive a whatsapp message, twilio provides callback url we can set (The configuration can be set in Messaging > Try it out > Send a WhatsApp message > Sandbox settings)
    - `When a message comes in`(this is where we can receive a message from the user) : `{MY_API_BASE_URL}/twilio/whatsapp/`
    - `Status callback URL`(this is where we can find out the status of the message we sent) : `{MY_API_BASE_URL}/twilio/status-callback/`

### Use `DynamoDB` as backend Database

- I usually prefer using RDB like MySQL or PostgreSQL as a database server. But, I have no money to pay for. I use DynamoDB for almost no cost.
- Here the tables I created
  - `customers`: customer info table
  - `fcm-sents`: messages sent via FCM.
  - `fcm-tokens`: users' fcm tokens.
  - `orders`: order info table
  - `shops`: shop info table
  - `socket-messsges`: messages sent via WebSocket
  - `sockets`: websockets that client(the printer app) connected. contains `connectionId`
  - `telegram-users`: user info table for telegram user
  - `telegram-webhooks`: messages received from telegram
  - `twilio-users`: user info table for whatsapp user
  - `twilio-webhooks`: messages received from the twilio
  - `users`: not yet implemented yet. currently, relies on `cognito` only.
  - `usershops`: the mapping table for user and shop

### Use `Cognito` as user database

- Create `User pool` to host users.
- use `Federated identity providers` to provide users option to login via `Google` or `Apple` or `SAML` or etc.
- Cognito provides `self registration`, `password policy`, `password recovery`, and `MFA`(not tested yet)
- Cognito provides `Hosted UI` for user login, and also can be integrated into application using `OAuth` protocol.

### PWA

- The app created with `create-react-app` already contains the `PWA` stuff (/public/manifest.json)
- So, the user can `Install` as chrome app, and can `Added to Home Screen` in iOS.
- In iOS, the installed PWA app can also receive `PUSH Notification`

### FCM

- The FCM is push notification service provided by Google.
- The FCM can send to a following targets
  - iOS App(Native app)
  - Chrome Web
  - Chrome PWA
  - (and finally) iOS PWA App!!: but, I think there are some limitation in functionality.
- To get a `FCM Token` in a browser(or PWA)
  - firebase part
    ```javascript
    export const app = initializeApp(firebaseConfig);

    export const registerServiceWorker = async () => {
      try {
        return navigator.serviceWorker
          .getRegistration()
          .then((worker) => {
            if (worker) {
              return worker;
            } else {
              return navigator.serviceWorker
                .register(`${process.env.PUBLIC_URL}/firebase-messaging-sw.js`)
                .then((worker) => {
                  return worker;
                });
            }
          })
          .catch((e) => {
            console.error(e);
          });
      } catch (e) {
        console.error(e);
      }
    };

    export const getFcmToken = async (swRegistration) => {
      if (!swRegistration) {
        alert('not supported');
        return;
      }
      try {
        const messaging = fcm.getMessaging(app);
        return fcm
          .getToken(messaging, {
            serviceWorkerRegistration: swRegistration,
            vapidKey: VAPIDKEY,
          })
          .then((currentToken) => {
            if (currentToken) {
              // Send the token to your server and update the UI if necessary
              console.log('GotToken');
              console.log(currentToken);
              return currentToken;
            } else {
              // Show permission request UI
              alert('no registration token available');
              console.error(
                'No registration token available. Request permission to generate one.'
              );
            }
          })
          .catch((err) => {
            console.error('An error occurred while retrieving token. ');
            alert(err);
            console.error(err);
          });
      } catch (e) {
        console.log(e);
        alert(e);
      }
    };
    ```
  - UI Part
    ```javascript
    const enablePushNotication = () => {
      registerServiceWorker().then((swRegistration) => {
        getFcmToken(swRegistration).then((token) => {
          console.log(token);
          if (token && token.length > 0) {
            // here we send received token to the backend server
            shopApi.registerFcmToken(token).then((response) => {
              console.log(response);
              enqueueSnackbar('FCM Token registered', { variant: 'success' });
            });
          }
        });
      });
    };
    ```
- To send a message, I use `firebase-admin` sdk
  ```typescript
  import * as firebase from "firebase-admin";
  
  const serviceAccount = require("../../../service-account.json");
  
  const admin = firebase.initializeApp({
    credential: firebase.credential.cert(serviceAccount),
  });

  export const sendMessage = (fcmToken: string, message: string, data?: any) => {
    const messagePayload = {
      notification: {
        title: "New message",
        body: message,
      },
      data: Object.keys(stripUndefined(data)).length > 0 ? data : undefined,
      token: fcmToken,
    };

    return admin
      .messaging()
      .send(messagePayload)
      .then(async (result) => {
        // here we record result into `fcm-sents`
        return result;
      })
      .catch(async (err) => {
        // here we mark fcm token as bad in `fcm-tokens`
      });
  };

  ```

### WebSocket

- The final part is the `Tkinter` application, this application is for printing a `order receipt` to a `receipt thermal printer`
- a regular network printer for printing an `A4` document, then the printing function of any device can use. But to use `receipt thermal priner`, I created an app that uses [escpos](https://pypi.org/project/escpos/)
- Since its to be installed on a Mac OS or Linux OS, and to be simble, I chose `Tkinter` as user frontend.
- And, to get an `order` from the server, using a `poll` mechanism can be a `stressful` job to the server.
- I choose `WebSocket` server that is backed by `AWS WebSocket API Gateway`
  - Here is how can be defined
    ```yaml
    functions:
      connectHandler:
        handler: src/websocket/connect.handler
        events:
          - websocket:
              route: $connect

      disconnectHandler:
        handler: src/websocket/disconnect.handler
        events:
          - websocket:
              route: $disconnect

      # all the message is delivered to default handler
      defaultHandler:
        handler: src/websocket/default.handler
        events:
          - websocket:
              route: $default
    ```
  - When the client connects to a server, the `connect.handler` will record a `connectionId` to the database `sockets`
    ```typescript
      export const handler = async (event) => {
        await Socket.registerConnection(event.requestContext.connectionId);
        return {
            statusCode: 200,
            body: JSON.stringify({
                message: 'connectHandler',
                event,
            }),
        };
      }
    ```
  - When the client disconnects, the `disconnect.handler` will delete connection from the database
    ```typescript
    export const handler = async (event) => {
      await Socket.deleteConnection(event.requestContext.connectionId);
      return {
          statusCode: 200,
          body: JSON.stringify({
              message: 'disconnectHandler',
              event,
          }),
      };
    };
    ```
  - And the `default.handler` will handle the messages sent from the clients.
    ```typescript
    export const handler = async (event) => {
      console.log('event', JSON.stringify(event, null, 4));
      const connectionId = event.requestContext.connectionId;
      const requestId = event.requestContext.requestId;
      let messageData;

      const websocketUrl = getWebSocketEndpoint(event);
      const apiGatewayClient = new ApiGatewayManagementApiClient({
          endpoint: websocketUrl, // e.g., "your-api-id.execute-api.region.amazonaws.com/production"
      });
      try {
          const receivedBody = JSON.parse(event?.body);
          console.log('receivedBody', receivedBody);

          let message: Message;
          try {
              message = JSON.parse(event.body) as Message;
          } catch (error) {
              console.error('Invalid message format', error);
              return { statusCode: 400, body: 'Invalid message format' };
          }

          let response: Message;

          switch (message.type) {
              case MessageType.AUTH_REQUEST:
                  console.log('Received auth request', message);
                  const username = (message as AuthRequestMessage).data;
                  console.log('registering connection', connectionId, username);
                  await Socket.registerConnection(connectionId, undefined, username);
                  response = <AuthResponseMessage>{
                      type: MessageType.AUTH_RESPONSE,
                      status: 'success',
                      data: 'auth success',
                      requestMessageId: message.messageId,
                  }
                  break;
              case MessageType.CHAT:
                  console.log('Received chat message', message);
                  response = <ChatMessage>{
                      type: MessageType.CHAT,
                      data: 'chat received',
                  }
                  break;
              case MessageType.REQUEST:
                  console.log('Received request message', message);
                  response = <ResponseMessage>{
                      type: MessageType.RESPONSE,
                      status: 'success',
                      data: 'request received',
                      requestMessageId: message.messageId,
                  }
                  break;
              case MessageType.RESPONSE:
                  console.log('Received response message', message);
                  response = <ResponseMessage>{
                      type: MessageType.RESPONSE,
                      status: 'success',
                      data: 'response received',
                      requestMessageId: message.messageId,
                  }
                  break;
              default:
                  console.error('Unknown message type', message.type);
                  response = <ResponseMessage>{
                      type: MessageType.RESPONSE,
                      status: 'error',
                      error: {
                          code: 'unknown-message-type',
                          message: 'Unknown message type',
                      },
                      requestMessageId: message.messageId,
                  }
          }

          // to send a message to client, we should use api gateway method `postToConnection`
          const command = new PostToConnectionCommand({
              ConnectionId: connectionId,
              Data: JSON.stringify(response, null, 4),
          });

          await apiGatewayClient.send(command);
      } catch (err) {
          console.error('Error WSURL:', websocketUrl);
          console.error("Error posting to connection:", err);
          // Optionally handle stale connections by removing them from your database
          const command = new PostToConnectionCommand({
              ConnectionId: connectionId,
              Data: JSON.stringify({
                  messageId: `request-${requestId}`,
                  type: 'error',
                  status: 'error',
                  error: {
                      code: 'unknown-error',
                      message: err.message,
                  }
              }),
          });
          await apiGatewayClient.send(command);
      }

      // returning message is not sent to the client
      return { statusCode: 200, body: "Message sent." };
    };
    ```
- And the `PostToConnectionCommand` command is used when the user requests via API Server. (this is what I actually need, To send a Notification Message thing)
  ```typescript
  // print
  router.post(
    "/:orderId/print",
    asyncHandler(async (req, res) => {
      await checkPermission(req);
      const shop = await Shops.getShopByUid(req.params.shopUid);
      const order = await Orders.getOrder(req.params.orderId);
      if (!order) {
        throw new Error(`Order ${req.params.orderId} not found`);
      }

      const userShops = await Shops.getUsersForShop(shop.shopId);

      for (const userShop of userShops!) {
        // here I use `PostToConnectionCommand`
        await websocketSend(userShop.userId, order);
      }

      // print order
      res.json({ message: "Order printed", order });
    }),
  )
  ```
