Get specific column using `cut`. Tab is the default delimiter in cut

``` bash
# Get column
cat content | cut -d "delimiter" -f (field number)
```

Output specific column using `awk`
```bash
cat content | awk -F/ '{print $1}'
```

Create gzipped tar
```bash
tar -czvf archive.tgz file1 dir2
```

Extract gzipped tar
```bash
# output dir has to exist
tar -xzvf archive.tgz -C targetdir
```

Base64 encode (-n for no newline)

echo -n 'admin:password' | base64


Heredoc Syntax to create multi-line file from command line

``` bash
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