# mac-mdsplus-server

Minimal local MDSplus server for development and testing on macOS (via Podman, native ARM64).

This repo provides a reproducible way to:
- spin up a local `mdsip` server
- populate a small test tree
- connect using Python clients (e.g. `mdsthin`)

---

## Why this exists

MDSplus is typically deployed inside lab infrastructure and not exposed publicly.  
For local development (e.g. data source plugins, mapping tools), you need a **self-contained test server**.

This repo gives you that.

---

## Features

- Native **ARM64 MDSplus container** (no QEMU/emulation)
- Simple **test tree fixture** (`test`, shot `1`)
- One-command server startup
- Works with `mdsthin` and standard MDSplus clients

---

## Requirements

- Podman (macOS)
- Python (optional, for testing)

---

## Quick start

```bash
./run-local-server.sh


You should see:

✅ MDSplus server is ready

Check:

```bash
nc -vz localhost 8000
```


---

## Test connection (Python)

```python
from mdsthin import Connection

c = Connection("localhost:8000")
c.openTree("test", 1)

print(c.get(":IP").data())
print(c.get("dim_of(:IP)").data())
```

---

## Reset environment

```bash
./reset-tree-volume.sh
```

This removes:

the running container
the persistent test tree volume

--- 

## Test tree contents

Tree: `test`  
Shot: `1`

Nodes:
TOP:IP
TOP:DENSITY

Each contains a simple signal with a small timebase.

---

## Notes

- Server runs using:

```bash
mdsip -m -p 8000
```

A permissive mdsip.hosts file is injected for local testing
This is not secure — do not expose beyond localhost

## Troubleshooting

connection refused:
```bash
podman logs libtokamap-mdsplus-test
```
