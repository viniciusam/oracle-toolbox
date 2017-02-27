
CONTAINER_NAME=oracle-se-12
PASSWORD=oracle

docker run -d --name $CONTAINER_NAME \
-p 1521:1521 -p 5500:5500 \
oracle/database:12.1.0.2-se2

echo "Waiting database to get ready."
docker logs -f $CONTAINER_NAME | grep -m 1 "DATABASE IS READY TO USE!" --line-buffered

echo "Changing default password."
docker exec $CONTAINER_NAME ./setPassword.sh $PASSWORD

CONTAINER_IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' $CONTAINER_NAME)
echo "Container IP: $CONTAINER_IP"

#docker run --rm -ti oracle/database:11.2.0.2-xe sqlplus system/$PASSWORD@//$CONTAINER_IP:1521/XE <<SQL
#docker exec -ti oracle-11g-xe sqlplus system/oracle "SELECT SYSDATE FROM DUAL;"
