# GitHub Branch Protection & CI/CD Rules

This guide sets up branch protection rules to ensure code quality and prevent direct pushes to main.

## Step 1: Enable Branch Protection on Main

1. Go to GitHub repository → Settings → Branches
2. Click "Add rule" under "Branch protection rules"
3. Fill in branch name pattern: `main`

## Step 2: Configure Protection Rules

### Required Checks
✅ **Require status checks to pass before merging**
- Select: `analyze` (the lint workflow)
- Select: Any other quality checks you want

✅ **Require branches to be up to date before merging**
- Ensures code is based on latest main

### Review Requirements
✅ **Require pull request reviews before merging**
- Number of required reviewers: `1` (adjust as needed)
- Dismiss stale pull request approvals when new commits are pushed

✅ **Require approval from code owners**
- If you have a CODEOWNERS file

### Additional Protection
✅ **Restrict who can push to matching branches**
- Select: Only allow specific users/teams
- Or leave unchecked for all users

✅ **Allow force pushes**
- ❌ Unchecked (prevent force push accidents)

✅ **Allow deletions**
- ❌ Unchecked (prevent accidental deletions)

## Step 3: Setup CODEOWNERS File (Optional)

Create `.github/CODEOWNERS` to specify who reviews PRs:

```
# Main code ownership
* @BawiCeu16

# Domain-specific ownership
lib/provider/* @BawiCeu16
lib/pages/* @BawiCeu16
android/* @BawiCeu16
```

## Step 4: Create Develop Branch (Optional)

For staging before main release:

```bash
git branch develop
git push origin develop
```

Add same protection rules to develop branch:
- Pattern: `develop`
- Same configuration as main

## Workflow: Code Review Process

### For Contributors:

```bash
# 1. Create feature branch from main
git checkout -b feature/my-feature
git push origin feature/my-feature

# 2. Make changes and commit
git commit -m "feat: add new feature"
git push origin feature/my-feature

# 3. Create Pull Request on GitHub
# - Go to repository → Pull requests → New PR
# - Select base: main, compare: feature/my-feature
# - Add description
# - Click "Create pull request"

# 4. Wait for CI checks to pass
# - Analyze workflow runs automatically
# - Tests must pass before merge

# 5. Merge when approved
# - Click "Merge pull request"
# - Delete branch after merge
```

### For Releases:

```bash
# 1. After merging to main
git checkout main
git pull origin main

# 2. Use version bump workflow
# Go to Actions → Auto Version Bump and Release
# Select bump type and run

# 3. APK automatically builds and releases
```

## Step 5: Turn on Auto-Delete Head Branches

In repository Settings → General:
✅ **Automatically delete head branches**
- Cleans up merged feature branches

## Step 6: Configure PR Templates (Optional)

Create `.github/pull_request_template.md`:

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
How did you test this?

## Checklist
- [ ] Code follows project style
- [ ] Tests pass locally
- [ ] No new warnings
- [ ] Documentation updated

## Screenshots (if applicable)
```

## Monitoring & Insights

### View Workflow Status
- Click on any PR to see workflow status
- Red X = workflow failed
- Green ✓ = workflow passed

### Branch Insights
- Settings → Insights → Network
- See commit history and branch relationships

### Managing Secrets
- Settings → Secrets and Variables → Actions
- View/create repository secrets
- Used by workflows for signing, deployment, etc.

## Common Issues & Solutions

**"Branch protection not working"**
- Ensure you're not admin of repo (admins can bypass rules)
- Or enable "Include administrators" in protection rules

**"CI checks failing"**
- Click on the failing check to see logs
- Fix code analysis or test failures
- Push again to re-run

**"Can't merge because branch is out of date"**
- Click "Update branch" in PR
- Merges latest main into your branch

**"Protected branch not showing in list"**
- Make sure branch exists (create it first)
- Wait a few seconds for GitHub to index it

## Best Practices

✅ **DO:**
- Always work in feature branches
- Write clear PR descriptions
- Keep PRs small and focused
- Run tests locally before pushing
- Delete merged branches

❌ **DON'T:**
- Never force push to main
- Don't ignore CI failures
- Don't merge without review
- Don't commit to main directly
- Don't skip the PR process

## Managing Multiple Environments

### Branches:
- `main` - Production releases
- `develop` - Staging/testing
- `feature/*` - Feature development

### Tags:
- `v1.3.0` - Production release tag
- `v1.3.0-rc1` - Release candidate
- `v1.3.0-beta` - Beta version

## Advanced: Require Specific Commit Messages

Use branch rules to enforce commit convention:

```
Commit message pattern: ^(feat|fix|docs|style|refactor|test|chore):
```

This enforces: `feat: description` or `fix: description` etc.

## References

- [GitHub Branch Protection Documentation](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches)
- [GitHub Status Checks](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/collaborating-on-repositories/about-status-checks)
- [GitHub Insights & Metrics](https://docs.github.com/en/repositories/viewing-activity-and-data-for-your-repository/viewing-repository-insights)

