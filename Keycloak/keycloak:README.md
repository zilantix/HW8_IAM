# Keycloak Configuration – flask-realm

This realm was configured manually via the Keycloak Admin Console. Below are the main settings used to support the IAM demo.

---

## Realm Details

- **Realm Name**: `flask-realm`

## Client Configuration

- **Client ID**: `flask-client`
- **Access Type**: public
- **Direct Access Grants Enabled**: true
- **Valid Redirect URIs**: `*`
- **Root URL**: left blank
- **Standard Flow Enabled**: true

## Test User

- **Username**: `testuser`
- **Email**: `serpilsena@yahoo.de`
- **Password**: `Bubirest1001!`
- **Email Verified**: true
- **Enabled**: true

## Token Settings

- **Signature Algorithm**: RS256 (default)
- **Token Lifetime**: 300 seconds (5 minutes)
- **Issuer**: `http://localhost:8080/realms/flask-realm`

---

## Notes

- This configuration supports demo-level password-based login and token issuance.
- You can view and modify this via: [http://localhost:8080](http://localhost:8080)
- No `realm-export.json` was included, but configuration can be exported later using Keycloak's admin CLI.
