---
layout: post
title: "Common Docker Container Commands Reference"
date: 2025-07-15
categories: docker containers devops
---

# Common Docker Container Commands Reference

This post serves as a quick reference for common Docker container commands. The commands are organized in a table format for easy copying and use.

## Container Commands

### n8n (Workflow Automation Tool)

**Create persistent volume:**
```bash
docker volume create n8n_data
```

**Run container:**
```bash
docker run -it --rm \
  --name n8n \
  -p 5678:5678 \
  -v n8n_data:/home/node/.n8n \
  docker.n8n.io/n8nio/n8n
```

## Notes

- The commands above use common best practices for running containers
- Volume mounts (`-v`) are used to persist data
- Port mappings (`-p`) expose container ports to the host
- Container names are set using `--name` for easy reference
- Remove the `--rm` flag if you want the container to persist after stopping

## Tips

1. Always use meaningful container names for easier management
2. Consider using Docker Compose for more complex setups
3. Check container logs using `docker logs <container_name>`
4. Use `docker ps` to list running containers
5. Use `docker volume ls` to list all volumes

Feel free to suggest more container commands to add to this reference! 