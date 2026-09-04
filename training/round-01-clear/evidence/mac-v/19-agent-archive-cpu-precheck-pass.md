# B4-1 MAC-V — Agent Archive + CPU Precheck PASS

## Scope

This evidence records the read-only inspection of the provided B4-1 Agent archive and the host CPU architecture before installing the canonical Agent binary.

## Runtime context

- Repository: `/home/metastudy9997479/codyssey/codyssey-basic-system-monitor`
- Branch: `main`
- Host architecture: `x86_64`
- Archive: `agent-app.zip`
- Archive size observed: approximately 14 MB

## Required commands

The following commands were present:

- `unzip`
- `file`
- `find`

## Archive contents

The provided archive contained both supported Linux binaries:

- `agent-app-linux-x86`
- `agent-app-linux-arm64`

It also contained `__MACOSX` AppleDouble metadata files; these were not selected as runtime binaries.

## Architecture inspection

`file` reported:

- `agent-app-linux-x86`: ELF 64-bit LSB executable, `x86-64`
- `agent-app-linux-arm64`: ELF 64-bit LSB executable, ARM `aarch64`

Because the MAC-V Ubuntu guest reports `uname -m = x86_64`, the expected binary is:

```text
agent-app-linux-x86
```

The expected binary was found and its ELF architecture matched the host CPU.

## Final runtime gate

```text
[PASS] expected binary found
[PASS] supplied Agent binary matches host CPU
[PASS] B4-1 AGENT ARCHIVE + CPU PRECHECK
[PASS] temporary inspect directory removed
```

## Safety / hygiene

- No Agent binary was installed in this checkpoint.
- `/opt/agent-app/bin/agent-app` was not changed by this checkpoint.
- The archive was inspected in a unique `mktemp` directory and the temporary directory was removed afterward.
- No Secret value was read, printed, copied to chat, or stored in Evidence.

## State

- SSH + UFW: PASS
- IAM membership: PASS
- Filesystem + ACL: PASS
- Secret file policy: PASS
- Agent archive + CPU compatibility: PASS
- Canonical Agent binary/env installation: NOT RUN
- Agent Boot / TCP15034: NOT RUN
- B4-1 Mission CLEAR: NO
