---
layout: post
title: "Virtual Environment Cheatsheet"
date: 2020-03-23 08:00:00 -0400
comments: true
categories:
- cheatsheet
- shell
- ruby
- python
---

Quick reminder for myself when I need to switch between virtual environments.

`RVM` for Ruby
    
    # List existing environments
    rvm list

    # Create new environment
    rvm install 2.6.3

    # Set default
    rvm --default use 2.6.3

    # Switch back to system's ruby
    rvm use system

    # Use a specific version
    rvm use 2.1.1


`anaconda` for Python

    # List existing environments
    conda env list

    # Create new environment
    conda create --name py38 python=3.8

    # Activate environment
    conda activate py38

    # Deactivate active environment
    conda deactivate
