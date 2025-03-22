#!/bin/sh

# docker run image server
# docker run image client (bob|charlie) IP

mkdir /app && cd /app
cp -r /repo/app/src .

cat << EOF > requirements.txt
keras==3.9.0
tensorflow==2.18.0
EOF

pip install --no-cache-dir -r requirements.txt

echo "Installed the package successfully!"

if [ "$1" = "server" ]; then
  fx workspace create --prefix /app/mnist_example --template keras/mnist
  cd /app/mnist_example
  # setup without TLS
  sed -i 's/use_tls: true/use_tls: false/' plan/plan.yaml

  fx plan initialize -a $(hostname -i)

  echo "collaborators:
  - bob
  - charlie" > plan/cols.yaml

  echo "bob,0
charlie,1" > plan/data.yaml

  python -m http.server 8000 &
  exec fx aggregator start
elif [ "$1" = "client" ]; then
  mkdir plan
  curl -o plan/plan.yaml "$3:8000/plan/plan.yaml"
  curl -o plan/data.yaml "$3:8000/plan/data.yaml"
  exec fx collaborator start -n $2
else
  echo "Error: Unsupported command '$1'. Use 'server' or 'client'."
  exit 1
fi