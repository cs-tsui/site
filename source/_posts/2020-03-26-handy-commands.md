---
layout: post
title: "Commonly Used Commands"
date: 2020-03-31 18:12:00 -0400
comments: true
categories:
- cheatsheet
- shell
---

Get specific column using `cut`. Tab is the default delimiter in cut

```bash
cat content | cut -d 'delimiter' -f <field number>
```


Output specific column using `awk`

```bash
cat content | awk -F/ '{print $1}'
```


Base64 encode (-n for no newline)

```bash
echo -n 'admin:password' | base64
```


Create gzipped tar

```bash
tar -czvf archive.tgz file1 dir2
```


Extract gzipped tar

```bash
# Output dir has to exist
tar -xzvf archive.tgz -C targetdir
```


Heredoc Syntax to create multi-line file from command line

```bash
cat <<EOT > app-pod.yml
apiVersion: v1
kind: Pod
metadata:
  name: my-app-ui
  labels:
    app: my-app
spec:
  containers:
    - name: nginx-server
      image: nginx
EOT
```