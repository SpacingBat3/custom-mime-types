#!/bin/bash

DIRNAME="`dirname "$(which "$0")"`"
INSTALL_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/mime"

for file in "${DIRNAME}"/mimetypes/*.xml; do
    if [[ -f "${INSTALL_DIR}/packages/$(basename "$file")" ]]; then
        echo "MIME type: '$(basename "$file")' already installed, skipping..."
    else
        printf "Installing '$(basename "$file")' MIME type..."
        install -Dm644 "$file" "${INSTALL_DIR}/packages/$(basename "$file")" >/dev/null 2>&1 \
            && echo " Success!" \
            || {
	        code="$?"
	        echo " Failed! (Script returned '${code}'.)"
	        exit "$code"
            }
    fi
done
printf "Updating MIME database..."
update-mime-database "$INSTALL_DIR" >/dev/null 2>&1 \
    && echo " Success!" \
    || {
        code="$?"
        echo " Failed! (Script returned '${code}'.)"
        exit "$code"
    }
echo -e "\nSucceed installing mime types!\n"
echo "It is recommended to logout from your user account to make changes available."
echo -e "Please note changes done by installer are user-wide only, you will need to" \
        "\nredo following process for other users as well if you want them to recognize" \
        "\nthese mime types as well."