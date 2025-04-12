# GitHub Authentication Guide

## IMPORTANT: Security Notice
- The personal access token previously stored in this file has been exposed and should be revoked immediately
- Go to GitHub Settings > [Personal access tokens](https://github.com/settings/tokens) and delete the exposed token
- Never commit tokens or credentials to Git repositories

## Proper Way to Use Personal Access Tokens

1. Create a new token on GitHub:
   - Go to [GitHub Settings > Personal access tokens](https://github.com/settings/tokens)
   - Click "Generate new token"
   - Set appropriate permissions and expiration
   - Copy the token when it's displayed (it won't be shown again)

2. Use the token securely:
   ```bash
   git config --global credential.helper store
   git push  # When prompted, enter your GitHub username and PAT as password
   ```

3. Store tokens securely:
   - Use environment variables
   - Use a password manager
   - Consider using GitHub CLI (`gh auth login`)