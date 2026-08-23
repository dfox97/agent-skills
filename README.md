# Agent skills

A standalone collection of agent skills, plus an optional Docker Sandboxes environment for trying Danny's Claude Code workflow.

## Use the skills without Docker

[`skills/`](skills/) is the canonical skill collection. It has no dependency on Docker or Docker Sandboxes and can be installed in any compatible agent environment.

## Run the sandbox on Linux

### 1. Install Docker Engine and Docker Sandboxes

On Ubuntu 24.04 or later:

```sh
curl -fsSL https://get.docker.com | sudo SBX=1 sh
sbx login
```

See Docker's [installation documentation](https://docs.docker.com/ai/sandboxes/install/) for the complete host requirements.

### 2. Build and load the agent image

From this repository:

```sh
docker build -t danny-agent:latest .
docker image save danny-agent:latest -o /tmp/danny-agent.tar
sbx template load /tmp/danny-agent.tar
rm /tmp/danny-agent.tar
```

The [`Dockerfile`](Dockerfile) extends Docker's Claude Code sandbox template and copies the standalone skills into `~/.claude/skills` inside the image.

### 3. Select a workspace

Clone this repository beside the project you want to edit:

```text
repos/
├── agent-skills/
└── my-project/
```

Set the project path in [`.sbxenv.yaml`](.sbxenv.yaml):

```yaml
workspace: ../my-project
```

### 4. Run

```sh
sbx env run .
```

The project is mounted directly into the sandbox. Agent changes appear immediately in the normal host working tree, so Git continues to work normally outside the sandbox.

Run the same command later to reattach to the persistent sandbox.

## Rebuild after changing skills

```sh
sbx env rm .
docker build -t danny-agent:latest .
docker image save danny-agent:latest -o /tmp/danny-agent.tar
sbx template rm danny-agent:latest 2>/dev/null || true
sbx template load /tmp/danny-agent.tar
rm /tmp/danny-agent.tar
sbx env run .
```

Removing the sandbox does not delete the host workspace.
