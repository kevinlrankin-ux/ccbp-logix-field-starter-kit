# Governance Settings Schema (v1)

This repo uses a single governance settings file:

- governance/governance.settings.json

The Ledger Adapter reads this file under StrictMode; missing properties can throw unless fallbacks exist.

---

## Top-level keys

### governance_mode (required)

Allowed values:
- LIGHT - local-only, training-friendly, minimal enforcement
- ENTERPRISE - strict chain expectations + optional sink routing

---

## ledger object (required)

Required keys:
- ledger.jsonl_path
- ledger.csv_path
- ledger.enable_csv_mirror
- ledger.enable_hash_chain
- ledger.enable_anchor
- ledger.anchor_every_n_events

---

## Canonical example

{
  "governance_mode": "LIGHT",
  "ledger": {
    "jsonl_path": "ledger/hash_registry.jsonl",
    "csv_path": "ledger/hash_registry.csv",
    "enable_csv_mirror": true,
    "enable_hash_chain": false,
    "enable_anchor": false,
    "anchor_every_n_events": 25
  },
  "enterprise": {
    "sinks": {
      "sql":  { "enabled": false },
      "rest": { "enabled": false },
      "siem": { "enabled": false }
    }
  }
}

---

## Legacy compatibility

Older repos may use:
- mode (instead of governance_mode)
- ledger.csv_mirror_path (instead of ledger.csv_path)
- enterprise.csv_mirror (instead of ledger.enable_csv_mirror)
