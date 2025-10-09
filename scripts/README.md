# Scripts

This directory contains helper scripts used during development.

## rebrand.sh

**Status:** The rebranding has already been applied in the repository.  
This script is kept here for **transparency** and for **future use** if the project is updated from upstream.

### What it does
- Replaces user-facing strings `"TalkBack"` / `"Talkback"` with `"TalkBack FOSS"`.
- Updates the Gradle config (shared.gradle):
  ```groovy
  talkbackApplicationId = "com.android.talkback"
````

→

```groovy
talkbackApplicationId = "app.talkbackfoss"
```

* Ensures the process is **safe** (does not touch XML `name=""` attributes).
* Idempotent: running it multiple times will not duplicate `"FOSS"`.

### When to use

Run this script if:

* You pull a fresh version from upstream that has reverted to original branding.
* You need to re-apply the rebranding for consistency.

### Usage

```bash
./scripts/rebrand.sh
```

The script will abort if it detects unsafe patterns in XML attributes,
otherwise it will apply the rebranding and report success.
