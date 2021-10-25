#!/bin/bash

#Credit: https://trstringer.com/key-vault-certificate-expiration/

KEYVAULT="<add keyvault name>"
# KEYVAULTS="<space_delimited_list_of_vault_names>"

# for KEYVAULT in $KEYVAULTS; do
for CERT in $(az keyvault certificate list \
        --vault-name "$KEYVAULT" \
        --query "[].name" -o tsv); do
    EXPIRES=$(az keyvault certificate show \
        --vault-name "$KEYVAULT" \
        --name "$CERT" \
        --query "attributes.expires" -o tsv)
    PYCMD=$(cat <<EOF
from datetime import datetime
from dateutil import parser
from dateutil.tz import tzutc
expire_days = (parser.parse('$EXPIRES') - datetime.utcnow().replace(tzinfo=tzutc())).days
if expire_days > 0 and expire_days < 30:
    msg = "in {} days".format(expire_days)
elif expire_days > 0:
    msg = "No Action Needed"
else:
    msg = "already expired!!!"
print(msg)
EOF
    )
    EXPIRES_DELTA=$(python3 -c "$PYCMD")
    if [ "$EXPIRES_DELTA" != "No Action Needed" ]; then
        echo "$CERT (Vault: $KEYVAULT) expires on $EXPIRES ($EXPIRES_DELTA)"
        az keyvault certificate download --vault-name tele2 -n $CERT --file "$CERT.csr"
    fi
done
# done
