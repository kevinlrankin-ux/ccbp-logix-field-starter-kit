# Output Contract: BUILD_MANIFEST.json

Must include:
- status: PASS|FAIL
- repo, platform, profile
- evidence: list of checks performed + results
- hashes: sha256 for each generated artifact (when present)
- next_action: exact steps to fix if FAIL
