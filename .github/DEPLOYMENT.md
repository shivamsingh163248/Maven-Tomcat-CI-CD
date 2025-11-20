# Branch-based Deployment Configuration

## Branch Deployment Strategy

### 🌿 **Main Branch (`main`)**
- **Environment**: Production
- **Docker Tags**: `latest`, `main-YYYYMMDD-commit`
- **Auto-Deploy**: ✅ Yes
- **Approval Required**: ❌ No (auto-deploy)
- **Platforms**: linux/amd64, linux/arm64
- **Registry**: ghcr.io/shivamsingh163248/maven-tomcat-ci-cd

### 🔧 **Develop Branch (`develop`)**  
- **Environment**: Staging
- **Docker Tags**: `develop`, `develop-YYYYMMDD-commit`
- **Auto-Deploy**: ✅ Yes
- **Approval Required**: ❌ No
- **Platforms**: linux/amd64, linux/arm64
- **Registry**: ghcr.io/shivamsingh163248/maven-tomcat-ci-cd

### ⚡ **Feature Branches (`feature/*`)**
- **Environment**: Development
- **Docker Tags**: `feature-branch-name-YYYYMMDD-commit`
- **Auto-Deploy**: ✅ Yes
- **Approval Required**: ❌ No
- **Platforms**: linux/amd64
- **Registry**: ghcr.io/shivamsingh163248/maven-tomcat-ci-cd

### 🚀 **Release Branches (`release/*`)**
- **Environment**: Pre-production
- **Docker Tags**: `release-version-YYYYMMDD-commit`
- **Auto-Deploy**: ✅ Yes
- **Approval Required**: ❌ No
- **Platforms**: linux/amd64, linux/arm64
- **Registry**: ghcr.io/shivamsingh163248/maven-tomcat-ci-cd

### 🏷️ **Tagged Releases (`v*`)**
- **Environment**: Production Release
- **Docker Tags**: `v1.0.0`, `latest`
- **Auto-Deploy**: ✅ Yes
- **Approval Required**: ❌ No
- **Platforms**: linux/amd64, linux/arm64
- **Registry**: ghcr.io/shivamsingh163248/maven-tomcat-ci-cd

### 🔄 **Pull Requests**
- **Environment**: Preview (no Docker build)
- **Docker Tags**: ❌ None
- **Auto-Deploy**: ❌ No
- **Testing Only**: ✅ Build and test validation

## Docker Image Naming Convention

```
ghcr.io/shivamsingh163248/maven-tomcat-ci-cd:[tag]
```

### Tag Examples:
- `latest` - Latest main branch
- `main-20241121-a1b2c3d4` - Main branch with date and short commit
- `develop-20241121-e5f6g7h8` - Develop branch build
- `feature-user-auth-20241121-i9j0k1l2` - Feature branch build
- `release-v1.1-20241121-m3n4o5p6` - Release branch build
- `v1.0.0` - Tagged release
- `pr-42` - Pull request build (if enabled)

## Environment Variables in Docker

Each Docker image includes build-time information:

```bash
# Environment variables available in container
APP_VERSION=main-20241121-a1b2c3d4
APP_BRANCH=main
APP_COMMIT=a1b2c3d4
```

## Usage Examples

### Pull and run latest main branch:
```bash
docker pull ghcr.io/shivamsingh163248/maven-tomcat-ci-cd:latest
docker run -p 8080:8080 ghcr.io/shivamsingh163248/maven-tomcat-ci-cd:latest
```

### Pull and run specific develop build:
```bash
docker pull ghcr.io/shivamsingh163248/maven-tomcat-ci-cd:develop
docker run -p 8080:8080 ghcr.io/shivamsingh163248/maven-tomcat-ci-cd:develop
```

### Pull and run feature branch:
```bash
docker pull ghcr.io/shivamsingh163248/maven-tomcat-ci-cd:feature-new-ui-20241121-xyz123
docker run -p 8080:8080 ghcr.io/shivamsingh163248/maven-tomcat-ci-cd:feature-new-ui-20241121-xyz123
```

### Check image metadata:
```bash
docker inspect ghcr.io/shivamsingh163248/maven-tomcat-ci-cd:latest
```

## Workflow Triggers

| Event | Branches | Docker Build | Tags Created |
|-------|----------|--------------|--------------|
| Push | `main` | ✅ Yes | `latest`, `main-date-commit` |
| Push | `develop` | ✅ Yes | `develop`, `develop-date-commit` |
| Push | `feature/*` | ✅ Yes | `feature-name-date-commit` |
| Push | `release/*` | ✅ Yes | `release-version-date-commit` |
| Tag | `v*` | ✅ Yes | `v1.0.0`, `latest` |
| PR | `main`/`develop` | ❌ No | Test only |
| Manual | Any | ✅ Yes | Based on branch |

## Security and Permissions

- **Registry**: GitHub Container Registry (ghcr.io)
- **Authentication**: GitHub Actions token (automatic)
- **Visibility**: Public (can be changed to private)
- **Platforms**: Multi-architecture (AMD64/ARM64)
- **Vulnerability Scanning**: OWASP Dependency Check included