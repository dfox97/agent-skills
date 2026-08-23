FROM docker/sandbox-templates:claude-code

COPY --chown=agent:agent skills/ /home/agent/.claude/skills/
