# sf-org-setup

One-command Salesforce org setup for Tableau Next demos. Enables Data Cloud, Einstein, Tableau Next, deploys permission sets, creates the Analytics and Visualization agent, and configures optional features (Heroku connector, custom agents, Tableau embedding trust).

## Prerequisites

- Internet connection (the launcher installs dependencies for you if needed)
- **Windows:** Nothing else — PowerShell is built in
- **macOS:** Nothing else — the launcher installs Homebrew, PowerShell, and Salesforce CLI if missing

## Getting Started

### 1. Download the repo

Click the green **Code** button on GitHub > **Download ZIP**. Extract it anywhere.

Or if you have git:

```bash
git clone https://github.com/Sanpelegrino/sf-org-setup.git
```

### 2. Double-click the launcher

| Platform | File |
|----------|------|
| Windows  | **`Setup.bat`** |
| macOS    | **`Setup.command`** |

It will:

1. Check for dependencies and offer to install anything missing
2. Launch the setup script
3. Prompt you to pick or log in to your Salesforce org (opens a browser)
4. Run through all setup steps automatically

That's it. Follow the prompts in the window.

### 3. Wait for Data Cloud (if needed)

If Data Cloud is still provisioning (common on new orgs — takes 5–30 min), the script exits cleanly. All completed steps are saved. Double-click the launcher again and it picks up where it left off.

---

## Interactive Decisions

The script will ask you about two optional features during setup:

| Prompt | What it does | When to say Yes |
|--------|--------------|-----------------|
| **Set up Heroku connector?** | Adds a shared PostgreSQL database (from the PACE ICE curriculum) into Data Cloud as an external data connector. Gives you sample data to query immediately. | You want demo data in Data Cloud without uploading CSVs. |
| **Set up Tableau embedding for PACE and PACE-NEXUS?** | Registers your Salesforce org as a trusted identity provider on both Tableau Cloud sites so embedded dashboards authenticate automatically. Also adds your user to both sites. Requires a Tableau Personal Access Token (PAT). | You're embedding Tableau dashboards in Salesforce and need SSO working. |

If you're unsure, say **N** to both — the core setup (Data Cloud, Einstein, Tableau Next, permissions, default agent) runs regardless.

### Reckless Analyst (opt-in flag)

The "Reckless Analyst" is a custom Employee Agent with faster responses, fewer guardrails, and no inline chart generation. It runs alongside the default Analytics and Visualization agent in the Concierge sidebar. It is **not** deployed by default — pass `-CreateCustomAgent` if you want it:

```powershell
.\scripts\salesforce\org-setup\run-setup.ps1 -Alias MY-ORG -CreateCustomAgent
```

---

## Flags

These are for advanced/CLI usage. The launcher handles the defaults.

| Flag | Effect |
|------|--------|
| `-Alias <name>` | SF CLI alias for the target org. If omitted, the script shows a picker. |
| `-CreateCustomAgent` | Deploy the "Reckless Analyst" Employee Agent (not part of default setup). |
| `-NoConnectedApp` | Skip deploying the CommandCenterAuth connected app. |
| `-PacePatName` / `-PacePatSecret` | Supply Tableau PAT non-interactively (skips the prompt). |

---

## What the Script Does (in order)

1. Enables Data Cloud
2. Enables Einstein / Generative AI
3. Deploys `Access_Analytics_Agent` permission set
4. Deploys CommandCenterAuth connected app (unless `-NoConnectedApp`)
5. **— waits for Data Cloud to finish provisioning —**
6. Deploys `Tableau_Next_Admin_PSG` permission set group
7. Assigns the PSG to your user
8. Enables Tableau Next + Agentforce toggles
9. Flips Feature Manager flags (headless browser or manual)
10. Enables SLDS v2 dark mode
11. Creates + activates the Analytics and Visualization agent
12. Grants agent access via permission set
13. Registers Tableau Cloud sites
14. *(optional)* Heroku connector
15. *(optional, flag-gated)* Reckless Analyst agent (`-CreateCustomAgent`)
16. *(optional)* PACE/PACE-NEXUS Tableau trust

---

## Structure

```
Setup.bat                          Double-click to run (Windows)
Setup.command                      Double-click to run (macOS)
scripts/
  common/                          Shared PowerShell utilities
  salesforce/org-setup/            Step scripts + orchestrator
    lib/                           Helpers (API, state, HTML report, Playwright)
salesforce/
  force-app/                       Metadata deployed to the org
  specs/                           Agent specification YAML files
notes/
  org-setup-state/                 Per-org state (gitignored, tracks progress)
  registries/                      Org registry (connected app client IDs)
```
