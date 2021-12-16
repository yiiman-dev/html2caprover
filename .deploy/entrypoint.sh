#!/bin/sh

#
# Copyright (c) 2021.
# @author https://sms-meli.com
# @programmer YiiMan https://yiiman.ir
#
#

echo "🎬 entrypoint.sh: [$(whoami)]"

echo "🎬 start supervisord"

supervisord -c /home/.deploy/config/supervisor.conf