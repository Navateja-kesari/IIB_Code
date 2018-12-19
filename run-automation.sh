#!/bin/bash

#Print out arguments

echo $@

#Prepare XVFB to allow running IIT in headless mode

Xvfb :10 -ac &
export DISPLAY=:10

#Switch based on command passed, and call ant, passing the appropriate arguments as build properties

if [ "$1" == "build" ]
then
        ant -buildfile /prolifics/buildconductor/iib/build-iib-100-linux/build.xml assembleApp -Dbars.list="$2" -Dbar.$2.applications.list="$3" -DBUILD_HOME="/builds" -DBUILD_TOOLS="/prolifics/buildconductor/iib" -Dpbc.platform="tfs" -DIIT_BIN="/opt/ibm/iib-10.0.0.6/tools/iibt" -DMQSI_BIN="/opt/ibm/iib-10.0.0.6/server/bin"
else

	if [ "$1" == "deploy" ]
    then
    
    	#Initialize broker file
	
		if [ "$9" == "" ]
		then
    	
			echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
			<IntegrationNodeConnectionParameters Version=\"10.0.0\" host=\"$3\" integrationNodeName=\"$5\" listenerPort=\"$4\" userName=\"$7\" xmlns=\"http://www.ibm.com/xlmns/prod/websphere/iib/8/IntegrationNodeConnectionParameters\"/>" >> /builds/load/.broker
	
			BROKER_FILE="/builds/load/.broker"
	
		else
        
			BROKER_FILE="/builds/load/iib-assemblies/environments/$9"
        	   		
		fi
		
		ant -buildfile /prolifics/buildconductor/iib/build-iib-100-linux/build.xml deployApp -Dbars.list="$2" -DIIB_EXEC_GRP="$6" -Dbar.$2.brokerFile="$BROKER_FILE" -Diib.userId="$7" -Diib.password="$8" -DBUILD_HOME="/builds" -DBUILD_TOOLS="/prolifics/buildconductor/iib" -Dpbc.platform="tfs" -DIIT_BIN="/opt/ibm/iib-10.0.0.6/tools/iibt" -DMQSI_BIN="/opt/ibm/iib-10.0.0.6/server/bin"
	
	else

		if [ "$1" == "overrideAndDeploy" ]
        then
        
        	#Initialize broker file
	
			if [ "${11}" == "" ]
			then
    	
				echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
				<IntegrationNodeConnectionParameters Version=\"10.0.0\" host=\"$3\" integrationNodeName=\"$5\" listenerPort=\"$4\" userName=\"$7\" xmlns=\"http://www.ibm.com/xlmns/prod/websphere/iib/8/IntegrationNodeConnectionParameters\"/>" >> /builds/load/.broker
	
				BROKER_FILE="/builds/load/.broker"
	
			else
        	
				BROKER_FILE="/builds/load/iib-assemblies/environments/${11}"
        	   		
			fi
		
			ant -buildfile /prolifics/buildconductor/iib/build-iib-100-linux/build.xml overrideAndDeployApp -Dbars.list="$2" -DIIB_EXEC_GRP="$6" -Dbar.$2.brokerFile="$BROKER_FILE" -Diib.userId="$7" -Diib.password="$8" -Dbar.$2.applications.list="$9" -Dbar.$2.properties="iib-assemblies/environments/${10}" -DBUILD_HOME="/builds" -DBUILD_TOOLS="/prolifics/buildconductor/iib" -Dpbc.platform="tfs" -DIIT_BIN="/opt/ibm/iib-10.0.0.6/tools/iibt" -DMQSI_BIN="/opt/ibm/iib-10.0.0.6/server/bin"
        		       	
       	else
                
       		if [ "$1" == "restart" ]
        	then     
        	
        		#Initialize broker file
	
				if [ "$8" == "" ]
				then
    	
					echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
					<IntegrationNodeConnectionParameters Version=\"10.0.0\" host=\"$3\" integrationNodeName=\"$5\" listenerPort=\"$4\" userName=\"$6\" xmlns=\"http://www.ibm.com/xlmns/prod/websphere/iib/8/IntegrationNodeConnectionParameters\"/>" >> /builds/load/.broker
	
					BROKER_FILE="/builds/load/.broker"
	
				else
        
					BROKER_FILE="/builds/load/iib-assemblies/environments/$8"
        	   		
				fi         
		
				ant -buildfile /prolifics/buildconductor/iib/build-iib-100-linux/build.xml restartApp -Dbar.application="$2" -Diib.brokerFile="$BROKER_FILE" -Diib.host="$3" -Diib.port="$4" -Diib.execGrp="$5" -Diib.userId="$6" -Diib.password="$7" -DBUILD_HOME="/builds" -DBUILD_TOOLS="/prolifics/buildconductor/iib" -Dpbc.platform="tfs" -DIIT_BIN="/opt/ibm/iib-10.0.0.6/tools/iibt" -DMQSI_BIN="/opt/ibm/iib-10.0.0.6/server/bin"
        		       	
       		else
                
       			echo Error: You need to pass either the 'build', 'deploy', 'overrideAndDeploy' or 'restart' command as the first argument.
       		fi
		fi
	fi   
fi