---
layout: post
title: "DataPower QuickStart (Docker)"
date: 2020-03-12 21:44:35 -0400
comments: true
categories:
- IBM
- DataPower
---

Following the [IBM Developer Guide](https://developer.ibm.com/datapower/docker) on the Dockerized version of DataPower is a great way to start playing around with the DataPower application gateway.


There are some small gotchas that the guide does not mention and they are noted here.

### SSH Port Number

In the newer releases of DataPower in container form, the IDG process is not ran with root. Therefore using port 22 as the SSH port will fail since only root user is allowed to use ports under 1024. We have to make a small change to the target port mapping from 22 to 9022 (or another high numbered port number).

As seen in the [Developer Works answer found here](https://developer.ibm.com/answers/questions/394482/ssh-service-on-new-datapower-docker-container-will/):

    One of the changes in 7.6 is that by default, the DataPower Gateway process runs as the non-root drouter user inside the Docker container. Because of this, DataPower does not have permissions to use privileged ports.

So we make the simple change to 9022:

     docker run -it \
        -v $PWD/config:/drouter/config \
        -v $PWD/local:/drouter/local \
        -e DATAPOWER_ACCEPT_LICENSE=true \
        -e DATAPOWER_INTERACTIVE=true \
        -p 9090:9090 \
        -p 9022:9022 \
        -p 5554:5554 \
        -p 8000-8010:8000-8010 \
        --name idg \
        ibmcom/datapower

We can now enable ssh so we can log into the DataPower CLI and execute commands.


### Enable SSH
After logging into the CLI with username and password, we can enable SSH and designate the port.

Since we are port-forwarding via 9022, it will be the one used for SSH.

    idg# configure
    Global mode
    idg(config)# ssh 0.0.0.0 9022

    %	Pending

    SSH service listener enabled

If the port number selected is still in the privilege range (i.e. <1024), the confusing part in trying to bring up the SSH service via the web UI or the CLI is there aren't any obvious errors about why the SSH service does not come up (in the case of the Web UI) or why the service is reported as up but is not reachable (in the case of the CLI)

### Enable Web Admin UI

Port 9090 is one of the port we are exposing in the Docker run commands, and we use this to reach the web admin UI.

    idg(config)# web-mgmt 0 9090 9090;
    Web management: successfully started

When navigating to it in the browser via localhost, don't forget to specify `https`

    https://localhost:9090


### Enabling REST Management

This allows us to manage the gateway using its REST API

    idg(config)# rest-mgmt 0  5554
    REST management: successfully started

After enabling, we can check if its enabled by curl-ing the REST endpoing

    $ curl -k -u admin:admin https://localhost:5554/mgmt/config/default/RestMgmtInterface
    {

        "_links" : {

        "self" : {"href" : "/mgmt/config/default/RestMgmtInterface"}, 

        "doc" : {"href" : "/mgmt/docs/config/RestMgmtInterface"}}, 

        "RestMgmtInterface" : {"name" : "RestMgmt-Settings", 

        "_links" : {

        "self" : {"href" : "/mgmt/config/default/RestMgmtInterface/RestMgmt-Settings"}, 

        "doc" : {"href" : "/mgmt/docs/config/RestMgmtInterface"}}, 

        "mAdminState" : "enabled", 

        "LocalAddress" : "0.0.0.0", 

        "LocalPort" : 5554, 

        "ACL" : {"value": "rest-mgmt", 

        "href" : "/mgmt/config/default/AccessControlList/rest-mgmt"}, 

        "SSLConfigType" : "server"}}


### Saving the Configuration

If you would like for the config values to persist and be picked up next time the DataPower container gets restarted, we can persist the configs to files.

    idg(config)# write memory
    Overwrite previously saved configuration? Yes/No [y/n]: y
    Configuration saved successfully.

### Reference Commands and Outputs

    login: admin
    Password: *****

    Welcome to IBM DataPower Gateway console configuration. 
    Copyright IBM Corporation 1999, 2020 

    Version: IDG.2018.4.1.10 build 318002 on Feb 21, 2020 11:09:49 AM
    Delivery type: LTS
    Serial number: 0000001

    idg# configure
    Global mode
    idg(config)# ssh 0.0.0.0 9022

    %	Pending

    SSH service listener enabled

    idg(config)# web-mgmt 0 9090 9090;
    Web management: successfully started

    idg(config)# rest-mgmt 0  5554
    REST management: successfully started

    idg(config)# write memory
    Overwrite previously saved configuration? Yes/No [y/n]: y
    Configuration saved successfully.