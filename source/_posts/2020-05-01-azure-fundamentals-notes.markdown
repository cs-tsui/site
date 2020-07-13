---
layout: post
title: "Azure Fundamentals Notes"
date: 2020-05-03 15:00:00 -0400
comments: true
published: false
categories:
- Azure
- Cloud
---
### Load Balancers

Azure Traffic Manager
- Global Load balancer using DNS, across AZ regions
- External Load balancer - within regions
- Interal Load balancer - within an AZ virtual network


Azure Application Gateway
- Web traffic load balancer
- Operates at level 7, vs level 4 (TCP/UDP)


Azure Front Door
- Specifically for the HTTP web traffic
- Can be used together with AZ Traffic Manager, with FD handling HTTP traffic, and TM handling other protocols


### Azure Subscription
- separate for different levels of control
  - cost limit
  - organizational structure
  - environments
  - https://docs.microsoft.com/en-us/learn/modules/create-an-azure-account/media/4-billing-structure-overview.png
