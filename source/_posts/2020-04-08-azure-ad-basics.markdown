---
layout: post
title: "azure_ad_basics"
date: 2020-04-08 07:56:57 -0400
comments: true
published: false
categories: 
---

Azure AD is *NOT* an Azure subscription


Azure AD
- Management Groups
- Subscriptions (may be nested inside mgmt grps)
    - Must be part of a single active directory tenant (AD tenant may have multiple subscriptions)


Added user to a Domain Group on Prem -> can be added to cloud access group via AD Sync -> which is then granted access to the Azure subscription


### AD Connect

A user account can belong to many 'directories'. The user may be have different permissions in each of these directories. Subscriptions are
under directories.
