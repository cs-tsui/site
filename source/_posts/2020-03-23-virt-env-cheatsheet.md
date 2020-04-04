---
layout: post
title: "Virtual Environment Cheatsheet"
date: 2020-03-23 20:30:00 -0400
comments: true
categories:
- cheatsheet
- shell
- ruby
- python
---

For those who work with virual environments when developing, here's a handy cheatsheet in case you need to switch between various virt-envs.

`RVM` for Ruby

```bash
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
```

`anaconda` for Python

```bash
# List existing environments
conda env list

# Create new environment
conda create --name py38 python=3.8

# Activate environment
conda activate py38

# Deactivate environment
conda deactivate
```

`virtualenv` for Python

```bash
# Create new environment (using the current Python version)
virtualenv my-env

# Create new environment (using a different Python version)
virtualenv -p /usr/bin/python2.7 my-env

# Activate new environment
source my-env/bin/activate

# Deactivate active environment
deactivate
```
