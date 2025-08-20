# Linting & Code Security Testing Workflows
Some notes regarding these workflow files.

The workflow consists of the following stages:
- **Unit Testing**
- **Static Code Analysis (SAST)**
  - You should set the `SONAR_TOKEN` and `SONAR_HOST_URL` variables as secrets
  - For SonarQube to identify the correct project, create a `sonar-project.properties` file with the following content:
```conf
sonar.projectKey=YOUR-PROJECT-KEY
```
- **Security Analysis**
  - For GitLeaks, you can create a `.gitleaks.toml` file like the following:
```toml
title = "BNB Documentation Gitleaks Config"


[extend]
useDefault = true

[allowlist]
description = "Ignore placeholder API keys in docs/examples"
regexes = [
  '''Bearer YOUR_API_KEY''',
  '''<API_KEY>''',
  '''<TOKEN>'''
]

# Optionally ignore docs or readme files entirely
paths = [
  '''README.md''',
  '''docs/.*'''
]
```