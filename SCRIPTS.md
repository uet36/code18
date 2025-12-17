# Codespace helper scripts

This template provides two simple helper scripts that a student's fork can use
to report check results back to your platform via GitHub webhooks.

- `scripts/check.sh` — run `check50 --json .` and push `.check50/result.json` to the repo
- `scripts/submit.sh` — push the current HEAD to the `submit` branch so the platform can detect submission

You can add these scripts to an assignment repository and add the following to `package.json`:

```json
{
  "scripts": {
    "check": "./scripts/check.sh",
    "submit": "./scripts/submit.sh"
  }
}
```

Usage in a Codespace terminal:

```
npm run check
npm run submit
```
