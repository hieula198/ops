# ECS Mode: Build-time Environment Variable Injection Warning

## ⚠️ Important Note: Build-time Environment Variables for SPA (e.g. React)

When using the following step in your workflow to inject environment variables:

```yaml
- name: Decode environment variables
  run: |
    if [ -n "${{ secrets.ENVIRONMENT_BASE64 }}" ]; then
      echo "${{ secrets.ENVIRONMENT_BASE64 }}" | base64 --decode > .env
      echo "Environment variables decoded and saved to .env file."
    else
      echo "ENVIRONMENT_BASE64 secret is not set or empty"
    fi
```

**This will inject environment variables at build time of your Docker image.**

For Single Page Applications (SPA) like React, all environment variables injected at build time will be hardcoded into the final static bundle. This means you CANNOT change these variables at runtime without rebuilding the image.

### ⚠️ Best Practice
- Only inject build-time configuration (e.g. app name, version) this way.
- **Do NOT inject runtime state (e.g. API endpoint, secrets, feature flags) at build time.**
- For runtime configuration, use a config server, entrypoint script, or mount config files at container startup.

### Example: react.dockerfile

```dockerfile
FROM node:20-alpine AS user_builder
WORKDIR /app
COPY --from=installer /app/node_modules ./node_modules
COPY . .
# This will read .env at build time and hardcode values into the bundle
RUN yarn build
```

If your `.env` contains:
```
REACT_APP_API_URL=https://api.example.com
```
This value will be hardcoded into the JS bundle and cannot be changed at runtime.

**Recommendation:**
- Separate build-time and runtime configuration.
- For runtime, consider using an entrypoint script to inject environment variables into the static files before serving.

---

**Example entrypoint for runtime env injection (optional):**

```sh
#!/bin/sh
# entrypoint.sh
for file in /app/static/js/*.js; do
  sed -i "s|REPLACE_API_URL|$REACT_APP_API_URL|g" "$file"
done
exec "$@"
```

Then in your Dockerfile:
```dockerfile
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
```

---

**Summary:**
- Be careful with build-time environment variable injection for SPA.
- Do not inject dynamic state at build time if you need to change it at runtime.

