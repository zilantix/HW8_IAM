#!/bin/bash

echo "> Starting Docker containers..."
docker compose up -d

echo "> Waiting for Keycloak to become ready..."
until curl -s http://localhost:8080/realms/master > /dev/null; do
  sleep 2
done
echo " Ready."

echo "> Getting admin token..."
ADMIN_TOKEN=$(curl -s -X POST http://localhost:8080/realms/master/protocol/openid-connect/token \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "username=admin" \
  -d "password=admin" \
  -d "grant_type=password" \
  -d "client_id=admin-cli" | jq -r '.access_token')

echo "> Creating realm..."
curl -s -o /dev/null -w "%{http_code}" -X POST http://localhost:8080/admin/realms \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  -d '{"realm": "flask-realm", "enabled": true}' | grep -q "201" || echo " Realm may already exist."

echo "> Creating client..."
curl -s -o /dev/null -w "%{http_code}" -X POST http://localhost:8080/admin/realms/flask-realm/clients \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  -d '{
    "clientId": "flask-client",
    "enabled": true,
    "publicClient": true,
    "directAccessGrantsEnabled": true
}' | grep -q "201" || echo " Client already exists."

echo "> Deleting existing user testuser..."
EXISTING_USER_ID=$(curl -s -X GET http://localhost:8080/admin/realms/flask-realm/users?username=testuser \
  -H "Authorization: Bearer $ADMIN_TOKEN" | jq -r '.[0].id')

if [ "$EXISTING_USER_ID" != "null" ]; then
  curl -s -X DELETE http://localhost:8080/admin/realms/flask-realm/users/$EXISTING_USER_ID \
    -H "Authorization: Bearer $ADMIN_TOKEN"
fi

echo "> Creating user..."
curl -s -X POST http://localhost:8080/admin/realms/flask-realm/users \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  -d '{
    "username": "testuser",
    "enabled": true,
    "emailVerified": true,
    "firstName": "Test",
    "lastName": "User"
}'

USER_ID=$(curl -s -X GET http://localhost:8080/admin/realms/flask-realm/users?username=testuser \
  -H "Authorization: Bearer $ADMIN_TOKEN" | jq -r '.[0].id')

echo "> Setting user password..."
curl -s -X PUT http://localhost:8080/admin/realms/flask-realm/users/$USER_ID/reset-password \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  -d '{
    "type": "password",
    "value": "testuser",
    "temporary": false
}'

# ✅ Remove any pending required actions
curl -s -X PUT http://localhost:8080/admin/realms/flask-realm/users/$USER_ID \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  -d '{"requiredActions": []}'

echo "> Testing login with testuser..."
curl -s -X POST http://localhost:8080/realms/flask-realm/protocol/openid-connect/token \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=flask-client" \
  -d "grant_type=password" \
  -d "username=testuser" \
  -d "password=testuser"

echo -e "\n> DONE ✅"
