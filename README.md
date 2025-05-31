# Secure IAM Architecture

## Overview

This project demonstrates a secure Identity and Access Management (IAM) architecture built using **Keycloak** as the identity provider and a protected **Flask API** microservice. It implements OAuth 2.0 and OpenID Connect (OIDC) flows to ensure authenticated and authorized access to protected resources.

---

---

## Features Implemented

- 🔐 **Keycloak Configuration**
  - Custom Realm: `flask-realm`
  - Client: `flask-client` with public and direct access grants enabled
  - User: `testuser` with password authentication

- 🛡️ **Flask Microservice**
  - Protected route at `/protected`
  - JWT Bearer token validation with PyJWT

- 🔁 **Setup Automation**
  - `setup.sh`: Automates Keycloak realm/client/user creation
  - `Makefile`: Simplifies container management (`make up`, `make reset`)
  - Realm export: `realm-export.json` from container for reproducibility

- ✅ **Test Validation**
  - Verified access with valid access token
  - Denied access without token or invalid credentials

---

## Security Analysis (STRIDE)

| Threat | Description | Mitigation |
|--------|-------------|------------|
| **S**poofing | Unauthorized access via token reuse or injection | Only signed JWTs are accepted; user credentials are validated |
| **T**ampering | Token payload manipulation | Tokens are validated with Keycloak’s public key |
| **R**epudiation | User actions not auditable | Logging and user identity included in token claims |
| **I**nformation Disclosure | Token sniffing or exposure | HTTPS recommended; tokens have short TTL |
| **D**enial of Service | Malformed tokens flooding API | Flask validates token format early; Keycloak throttling available |
| **E**levation of Privilege | User gaining unauthorized access | Role-based access control via Keycloak realm roles |

---

## Lessons from the Okta Case Study

Inspired by real-world breaches:
- Emphasized **minimal user privilege**
- Enforced **token expiration and refresh**
- Centralized identity management
- Verified tokens with **issuer**, **audience**, and **expiry**

---
<img width="638" alt="image" src="https://github.com/user-attachments/assets/819a2954-02c2-44f6-a6e9-c3184a0ce27a" />




## Deliverables

-  `docker-compose.yml` — full deployment stack
-  `setup.sh` — automated Keycloak config
-  `app.py` — Flask app with JWT validation
-  `realm-export.json` — exported Keycloak realm
-  `architecture_Diagram.png`


