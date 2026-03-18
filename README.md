# GCP Always-Free e2-micro VM

Terraform project to provision a **free** Google Cloud Compute Engine VM using the [GCP always-free tier](https://cloud.google.com/free/docs/free-cloud-features).

---

## Free Tier Details

### Compute Engine (always-free)

| Resource | Free Allowance |
|---|---|
| VM | 1 × e2-micro instance/month (non-preemptible) |
| Disk | 30 GB standard persistent disk |
| Snapshots | 5 GB |
| Network egress | 1 GB/month (to most destinations) |
| External IP | 1 free (while attached to a running instance) |

> **Eligible regions only:** `us-west1` (Oregon), `us-central1` (Iowa), `us-east1` (South Carolina)
> This project defaults to `us-central1-a`.

### GKE (for reference)

The GKE cluster management fee ($0.10/hour) is **free globally** for one zonal Standard or Autopilot cluster per billing account — but worker nodes are billed separately, and e2-micro is too small (1 GB RAM) to serve as a GKE node. Minimum viable GKE node is e2-small (2 GB RAM).

---

## What Gets Provisioned

- **VM:** `free-vm`, e2-micro, Ubuntu 24.04 LTS, `us-central1-a`
- **Disk:** 30 GB `pd-standard` boot disk
- **Firewall rule:** `allow-ssh` — TCP port 22 open from `0.0.0.0/0`
- **Startup script:** installs SSH server, Node.js LTS, Claude Code CLI, Gemini CLI

---

## Prerequisites

- [gcloud CLI](https://cloud.google.com/sdk/docs/install) installed and authenticated
- [Terraform](https://developer.hashicorp.com/terraform/install) installed
- A GCP project with billing enabled

This project uses GCP project `genial-union-147408` by default. Change it in `variables.tf` if needed.

---

## Deployment

### 1. Enable Compute Engine API

```bash
gcloud config set project genial-union-147408
gcloud services enable compute.googleapis.com
```

### 2. Authenticate Terraform

```bash
gcloud auth application-default login
```

### 3. Init and apply

```bash
terraform init
terraform plan
terraform apply
```

After apply, Terraform prints the external IP and the SSH command:

```
Outputs:

external_ip = "34.x.x.x"
ssh_command = "gcloud compute ssh free-vm --zone=us-central1-a"
```

### 4. SSH into the VM

```bash
gcloud compute ssh free-vm --zone=us-central1-a
```

---

## Startup Script

`startup.sh` runs automatically on first boot and installs:

| Tool | Purpose |
|---|---|
| `openssh-server` | SSH access |
| `nodejs` (LTS) | JavaScript runtime via NodeSource |
| `@anthropic-ai/claude-code` | Claude Code CLI (Anthropic agentic AI) |
| `@google/gemini-cli` | Gemini CLI (Google agentic AI) |

To view startup script logs on the VM:

```bash
sudo journalctl -u google-startup-scripts.service
# or
sudo cat /var/log/syslog | grep startup
```

---

## Destroy

To tear down all provisioned resources (VM + firewall rule):

```bash
terraform destroy
```

Terraform prompts for confirmation before deleting. Your Terraform files and this repo remain intact — re-run `terraform apply` to recreate everything.

---

## Keeping It Free

| Rule | Why |
|---|---|
| Only 1 e2-micro at a time | Free hours = total hours in the month; running 2 instances doubles usage and exceeds the limit |
| Do NOT use Spot/preemptible | Free tier covers regular (on-demand) instances only |
| Stay under 30 GB disk | Extra disk incurs storage charges |
| Keep egress under 1 GB/month | Egress to China and Australia is not covered by free tier |
| Do not resize the machine type | Changing to e2-small or larger triggers billing |

---

## File Structure

```
gcp-free-vm/
├── .gitignore      # excludes .terraform/, state files, and .tfvars
├── main.tf         # VM resource + SSH firewall rule
├── variables.tf    # project, region, zone defaults
├── outputs.tf      # external IP and SSH command
└── startup.sh      # first-boot provisioning script
```

---

## Existing GCP Configuration on This Machine

| Item | Details |
|---|---|
| gcloud SDK | v554.0.0 at `~/google-cloud-sdk/` |
| Active account | `affanzbasalamah@gmail.com` |
| Active project | `genial-union-147408` |
| Alt account | `affanzbasalamah@protonmail.com` |
| Alt project | `quiet-result-262820` |
| kubectl | Configured for local k3s cluster (`k3s.ziti`), not GKE |
| Terraform (other) | OCI (Oracle Cloud) config in `~/salamahcloud/` |
