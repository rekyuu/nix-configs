#! /usr/bin/env bash

INPUT=$(</dev/stdin)

# echo "state: $CLIPBOARD_STATE"
# echo "input: $INPUT"

if [[ "$CLIPBOARD_STATE" == "nil" ]]; then echo "is nil clipboard"; exit 0; fi
if [ -z "$INPUT" ]; then echo "is empty or undefined"; exit 0; fi
if [ ! -n "$INPUT" ]; then echo "is no bytes"; exit 0; fi
if [[ "$INPUT" == "" ]]; then echo "is empty"; exit 0; fi
if [ "$INPUT" = $'\n' ]; then echo "is single newline"; exit 0; fi

OUTPUT="$INPUT"

# URL_REGEX="(https?|ftp|file)://[-[:alnum:]\+&@#/%?=~_|!:,.;]*[-[:alnum:]\+&@#/%=~_|]"
TWITTER_REGEX="https://(twitter|x).com/[A-Za-z0-9_]+/status/[0-9]+"
if [[ "$OUTPUT" =~ $TWITTER_REGEX ]]
then
    # Remove URL parameters
    OUTPUT=${OUTPUT%\?*}

    # Make fixupx
    OUTPUT=${OUTPUT//https:\/\/x.com\//https:\/\/fixupx.com\/}
fi

if [[ "$INPUT" == "$OUTPUT" ]]; then echo "input unchanged"; exit 0; else echo "updating clipboard"; fi

echo "$OUTPUT" | wl-copy --trim-newline
