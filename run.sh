#!/bin/zsh
SCRIPT=$(realpath "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
cd "$SCRIPTPATH"

docker-compose up -d glusterfs1 glusterfs2 glusters3
echo "Sleep 10 seconds to wait the glusterfs up"
sleep 10
docker-compose exec glusterfs1 gluster peer probe glusterfs2
docker-compose exec glusterfs1 gluster volume create test-volume replica 2 transport tcp glusterfs1:/data/glusterfs/test glusterfs2:/data/glusterfs/test
docker-compose exec glusterfs1 gluster volume start test-volume
docker-compose exec glusterfs1 setfacl -m u:1000:rwx /data/glusterfs/test
docker-compose exec glusterfs2 setfacl -m u:1000:rwx /data/glusterfs/test
docker-compose exec glusterfs1 tail -f /var/log/glusterfs/bricks/data-glusterfs-test.log
