#!/bin/bash

( echo "
*/15 * * * * /var/watchtower/scripts/take_all_photos.sh
" ) | crontab -
