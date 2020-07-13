---
layout: post
title: "DataPower GatewayScript Remote Debugging"
date: 2020-07-07 19:54:43 -0400
comments: true
published: true
categories:
- datapower
- ibm
- gatewayscript
- VS Code
---

## Remote Debugging with Visual Studio Code

This short guide will show how to connect a remote debugger like Visual Studio Code or Chrome DevTools to help debug your GatewayScript, allowing you to inspect variables and step through lines of code to help with troubleshooting and development.

## Enabling GatewayScript Remote Debugging

First we need to enable remote debugging. Search `gatewayscript remote debugger` and set to `enabled`. Make sure the port is accessible from your local machine.

For example, if DataPower is running on local Docker, use `docker run ... -p 9229:9229 ...` to expose the port. If running on Kubernetes/Openshift, use `kubectl port-forward dp-pod 9229:9229` so it is accessible via `localhost`.

![remote-debugging](images/gatewayscript-remote-debugging/enable-remote-debugging.png)


Then in the script that you want to debug, add in the `debugger;` statement to trigger the debugger during execution.

![gwscript-debugger](images/gatewayscript-remote-debugging/script-example.png =450x)


Also, we need to enable debugging for the GatewayScript Action.

![action-debugging](images/gatewayscript-remote-debugging/enable-action-debug.png =450x)


## Connecting with Visual Studio Code

First we need to create a `launch.json` file to tell VS Code how to connect to the DP Debugging interface:

![vscode-debug-launch](images/gatewayscript-remote-debugging/e =450x)

Then use the `node` type and `inspector` protocol in the configuration as follows. Set `timeout` to be a larger number so it won't time out while you trigger the policy/gatewayscript action.

```
{
    "version": "0.2.0",
    "configurations": [
        {
            "type": "node",
            "request": "attach",
            "name": "Attach to DP",
            "address": "localhost",
            "port": "9229",
            "protocol": "inspector",
            "timeout": 100000
          }
    ]
}
```
Press `Run` to start the debugger, and then trigger your gatewayscript action.
It 

![vscode-debug-statement](images/gatewayscript-remote-debugging/debugger-breakpoint.png)

You can also see the status of the debug action in DataPower by searching for `Debug Action Status` to see any live debug sessions.


![vscode-debug-statement](images/gatewayscript-remote-debugging/debug-action-status.png)


## Connecting with Chrome DevTools

Connecting with Chrome DevTools is quite straight-forward. Navigate to `chrome://inspect/#devices`, and press `Configure..` to add your debugging address/port (e.g. `localhost:9229`) to the list if it doesn't already exist. When the GWS action is triggered, the debug session should show up and you can then click on `inspect` to show the debugger.


![vscode-debug-statement](images/gatewayscript-remote-debugging/chrome-debugger.png)


## References

https://www.ibm.com/support/knowledgecenter/SS9H2Y_7.7.0/com.ibm.dp.doc/debugger_remotedebugging.html

https://github.com/ibm-datapower/datapower-tutorials/blob/master/gatewayscript-remote-debugging/gateway-script-remote-debugging.md

https://code.visualstudio.com/docs/nodejs/nodejs-debugging