
Get specific column using `cut`. Tab is the default delimiter in cut

``` bash
# Get column
cat content | cut -d "delimiter" -f (field number)
```

Output specific column using `awk`
```bash
cat content | awk -F/ '{print $1}'
```

Heredoc Syntax

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