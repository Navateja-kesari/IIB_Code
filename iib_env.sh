#!/bin/bash
# © Copyright IBM Corporation 2015.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html

# Only run setmqenv if we already have a populated /var/mqm
# This allows us to point BASH_ENV at this file, even if mq.sh hasn't yet populated /var/mqm

if [ "$(ls -A /var/mqm)" ]; then
#        echo "Setting MQ environment profile"
	source /opt/mqm/bin/setmqenv -s
fi


if [ -z "$MQSI_VERSION" ]; then
#  echo "Setting IIB environment profile"
  source /opt/ibm/iib-10.0.0.6/server/bin/mqsiprofile
fi