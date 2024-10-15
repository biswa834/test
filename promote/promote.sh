CONFIG_FILE="/mnt/partnerportal_rnd/Scripts/config.json"
# Loop over each key in the JSON and export it as an environment variable
keys=$(jq -r 'keys[]' "$CONFIG_FILE")

for key in $keys; do
    value=$(jq -r --arg k "$key" '.[$k]' "$CONFIG_FILE")
    export "$key=$value"
done


echo "sourceSpinnOffAppId $sourceSpinnOffAppId"
echo "DestSpinnOffAppId $DestSpinnOffAppId"
echo "SoureAppName $SoureAppName"
echo "DestAppName $DestAppName"
echo "parent_mongo_ip $parent_mongo_ip"
echo "pulledResourcePath $pulledResourcePath"
echo "parent_mongo_ip $parent_mongo_ip"
echo "parent_mongo_dataBaseName $parent_mongo_dataBaseName"
echo "parent_mongo_user $parent_mongo_user"
echo "parent_mongo_password $parent_mongo_password"
echo "spinoff_mongo_ip $spinoff_mongo_ip"
echo "spinoff_mongo_user $spinoff_mongo_user"
echo "spinoff_mongo_password $spinoff_mongo_password"
echo "mongoCleanupScriptPath $mongoCleanupScriptPath"

logger_file_name=`date +%s`.txt
logger_file_path=${ec2path}/logger/
abs_logger_file_path=$logger_file_path/$logger_file_name
logger() {
    echo ">> `date +"%d-%m-%y %T"` - $1" >> $abs_logger_file_path
}

#partnerPortal Mongo Details
parent_mongo_connection_string="mongodb+srv://$parent_mongo_ip/$parent_mongo_dataBaseName"

#getting the source app DB details started
applogSource=`mongosh --quiet $parent_mongo_connection_string -u $parent_mongo_user -p $parent_mongo_password --eval "EJSON.stringify(db.applog.findOne({'parentId': $sourceSpinnOffAppId}, {'_id': 0}))"`

echo "applogSource $applogSource"

source_applogDbDetails=`echo $applogSource | jq '.dbDetails'`
source_spinnOffAppMongodbName=`echo $source_applogDbDetails | jq '.mongodb' | tr -d '"'`
source_spinnOffAppAlertdbName=`echo $source_applogDbDetails | jq '.alertdb' | tr -d '"'`
source_spinnOffAppAdmindbName=`echo $source_applogDbDetails | jq '.admindb' | tr -d '"'`
source_spinnOffAppRootdbName=`echo $source_applogDbDetails | jq '.rootdb' | tr -d '"'`
source_spinnOffAppDwdbName=`echo $source_applogDbDetails | jq '.dwdb' | tr -d '"'`

echo "source_spinnOffAppMongodbName $source_spinnOffAppMongodbName"
echo "source_spinnOffAppAlertdbName $source_spinnOffAppAlertdbName"
echo "source_spinnOffAppAdmindbName $source_spinnOffAppAdmindbName"
echo "source_spinnOffAppRootdbName $source_spinnOffAppRootdbName"
echo "source_spinnOffAppDwdbName $source_spinnOffAppDwdbName"
#getting the source app DB details ended
pulledResources_temp_dump_source=$pulledResourcePath/$SoureAppName
pulledResources_temp_dump_dest=$pulledResourcePath/$DestAppName

#getting the dest app DB details started
applogDest=`mongosh --quiet $parent_mongo_connection_string -u $parent_mongo_user -p $parent_mongo_password --eval "EJSON.stringify(db.applog.findOne({'parentId': $DestSpinnOffAppId}, {'_id': 0}))"`

echo "applogDest $applogDest"

dest_applogDbDetails=`echo $applogDest | jq '.dbDetails'`
echo "dest_applogDbDetails $dest_applogDbDetails"
dest_spinnOffAppMongodbName=`echo $dest_applogDbDetails | jq '.mongodb' | tr -d '"'`
dest_spinnOffAppAlertdbName=`echo $dest_applogDbDetails | jq '.alertdb' | tr -d '"'`
dest_spinnOffAppAdmindbName=`echo $dest_applogDbDetails | jq '.admindb' | tr -d '"'`
dest_spinnOffAppRootdbName=`echo $dest_applogDbDetails | jq '.rootdb' | tr -d '"'`
dest_spinnOffAppDwdbName=`echo $dest_applogDbDetails | jq '.dwdb' | tr -d '"'`

echo "dest_spinnOffAppMongodbName $dest_spinnOffAppMongodbName"
echo "dest_spinnOffAppAlertdbName $dest_spinnOffAppAlertdbName"
echo "dest_spinnOffAppAdmindbName $dest_spinnOffAppAdmindbName"
echo "dest_spinnOffAppRootdbName $dest_spinnOffAppRootdbName"
echo "dest_spinnOffAppDwdbName $dest_spinnOffAppDwdbName"
#getting the dest app DB details ended

mongo_uri="mongodb+srv://$spinoff_mongo_ip/"

#Mongo dump from Source Process Stared
source_schema_location=$pulledResources_temp_dump_source/DB_Dump/promoteSourceBackup/mongo_dump
source_mongo_connection_string="mongodb+srv://$spinoff_mongo_ip/$source_spinnOffAppMongodbName"

#collections=("app_config" "application_entities" "box" "bundle" "config" "sample" "sequences" "template" "topicDetails" "upload_conf")
collections="app_config,application_entities,box,bundle,config,sample,sequences,template,topicDetails,upload_conf"
IFS=','
#for (( i=0; i<${#collections[@]}; i++ ));do
for collection in $collections; do
	echo "collection : $collection"
	echo mongodump $source_mongo_connection_string -collection $collection -u $spinoff_mongo_user -p $spinoff_mongo_password $source_schema_location
	mongodump --uri $source_mongo_connection_string --collection $collection -u $spinoff_mongo_user -p $spinoff_mongo_password --out  $source_schema_location
done
sh $mongoCleanupScriptPath $dest_spinnOffAppMongodbName

#mongodump --host localhost:31083 --db grc_test --collection ${collections[$i]} --out /home/ubuntu/Santanu/Scripts/partnerPoratl/dump

#Mongo dump from Source Process Stared

#Mongo Restore at Dest Process Stared
dest_mongo_connection_string="$mongo_uri/$dest_spinnOffAppMongodbName"
admin_user="${parentMongoUser}"
admin_psw="${parentMongoPwd}"
admin_db_name="admin"
mongoSchemaDumpLocation=$source_schema_location/$source_spinnOffAppMongodbName
echo "mongoSchemaDumpLocation $mongoSchemaDumpLocation"
echo mongorestore --authenticationDatabase=$admin_db_name --uri $mongo_uri -u $admin_user -p $admin_psw -d $dest_spinnOffAppMongodbName $mongoSchemaDumpLocation
mongorestore --authenticationDatabase=$admin_db_name --uri $mongo_uri -u $admin_user -p $admin_psw -d $dest_spinnOffAppMongodbName $mongoSchemaDumpLocation
#Mongo Restore at Dest Process ended


pg_host="${pgHost}"
pg_port=${pgPort}
pg_userName="${pgUserName}"
pg_password="${pgPassword}"
pg_defaultDB="${pgDefaultDB}"
source_pgDump=$pulledResources_temp_dump_source/DB_Dump/promoteSourceBackup/pg_dump



tables="rbac_bundle,rbac_bundle_security_key,rbac_privilege,rbac_role,rbac_role_has_adhoc_entity,rbac_role_has_dashboard_entity,rbac_role_landing_page,rbac_user_has_roles"
IFS=','

#pg cleaning activity
for table in $tables; do
	echo "table name : $table"
	PGPASSWORD="$pg_password" psql -h $pg_host  -p $pg_port -U $pg_userName -d $dest_spinnOffAppAdmindbName -c "TRUNCATE TABLE $table CASCADE"
done

#exporting role data from source admin db to dest admin db
for table in $tables; do
	echo "table name : $table"
    PGPASSWORD="$pg_password" pg_dump --data-only --column-inserts -h $pg_host  -p $pg_port -U $pg_userName -d $source_spinnOffAppAdmindbName -t $table > "$source_pgDump/${table}.sql"
    PGPASSWORD="$pg_password" psql -h $pg_host  -p $pg_port -U $pg_userName -d $dest_spinnOffAppAdmindbName -f "$source_pgDump/${table}.sql"
done


#application apprepo folder copy process from source app to destination app
logger "Log - promote copy folder started"
logger "Log - promoteefscopy file for copy source efs to destination efs : sh promoteefscopy.sh $sourceSpinnOffAppId $DestSpinnOffAppId"
sh ${ec2path}/Scripts/promote/promoteefscopy.sh $sourceSpinnOffAppId $DestSpinnOffAppId
logger "promote executed thank you..."
#application apprepo folder copy process from source app to destination app finished
