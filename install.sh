path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) 
folder=$(echo $path | awk -F/ '{print $NF}')
tag=v0.59.0

cd /root
mkdir t3rn
cd t3rn
wget https://github.com/t3rn/executor-release/releases/download/$tag/executor-linux-$tag.tar.gz
tar -xzf executor-linux-$tag.tar.gz
