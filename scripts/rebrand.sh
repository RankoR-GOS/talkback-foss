#!/usr/bin/env bash

# Rebrand "TalkBack" → "TalkBack FOSS" in strings.xml files,
# and update applicationId in shared.gradle.
# Safe to run multiple times (idempotent).

set -euo pipefail

#######################################
# Step 1: Safety check for XML attributes
#######################################
if grep -qRE 'name="[^"]*Talk[Bb]ack[^"]*"' \
  braille/brailleime/src/phone/res/values*/strings*.xml \
  talkback/src/main/res/values*/strings*.xml; then
  echo "⚠️  WARNING: Found TalkBack/Talkback inside a name attribute."
  echo "    Aborting to avoid breaking identifiers."
  exit 1
fi

#######################################
# Step 2: Perform XML rebranding (idempotent)
#######################################
# Replace only plain "TalkBack" / "Talkback" not already followed by " FOSS"
perl -pi -e 's/\bTalkBack\b(?! FOSS)/TalkBack FOSS/g' \
  braille/brailleime/src/phone/res/values*/strings*.xml \
  talkback/src/main/res/values*/strings*.xml

perl -pi -e 's/\bTalkback\b(?! FOSS)/TalkBack FOSS/g' \
  braille/brailleime/src/phone/res/values*/strings*.xml \
  talkback/src/main/res/values*/strings*.xml

echo "✅ XML strings rebranding completed (idempotent)."

#######################################
# Step 3: Update applicationId in Gradle config
#######################################
GRADLE_FILE="shared.gradle"

if grep -q 'talkbackApplicationId *= *"com.android.talkback"' "$GRADLE_FILE"; then
  sed -i \
    's/talkbackApplicationId *= *"com\.android\.talkback"/talkbackApplicationId = "app.talkbackfoss"/' \
    "$GRADLE_FILE"
  echo "✅ Gradle applicationId updated in $GRADLE_FILE."
else
  echo "ℹ️  No matching talkbackApplicationId found in $GRADLE_FILE (already updated?)."
fi

#######################################
# Final message
#######################################
echo "🎉 Rebranding script executed successfully."
