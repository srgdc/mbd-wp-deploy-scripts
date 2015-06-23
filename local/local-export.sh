#!/bin/bash
NOW=$(date +"%Y-%m-%d-%H%M")
LOCAL_PROJECT_NAME="saferstdtesting"
LOCAL_FILE="$LOCAL_PROJECT_NAME.local.tar"
LOCAL_PROJECT_ROOT_DIR="c/xampp/htdocs/$LOCAL_PROJECT_NAME"
LOCAL_DESTINATION_DIR="/$LOCAL_PROJECT_ROOT_DIR/deploy/$NOW"
LOCAL_TMP_DIR="/$LOCAL_PROJECT_ROOT_DIR/tmp"
LOCAL_HTTPDOCS_DIR="/$LOCAL_PROJECT_ROOT_DIR/httpdocs"
LOCAL_DB_NAME="saferstdtesting"
LOCAL_DB_USER="root"
LOCAL_DB_PASS=""
LOCAL_DB_FILE="$LOCAL_DB_NAME.local.sql"
FILES_TO_EXCLUDE="/$LOCAL_PROJECT_ROOT_DIR/scripts/local/local-export-exclude.txt"

HTTPDOCS_TRANSFORM="s,^$LOCAL_PROJECT_ROOT_DIR/httpdocs,httpdocs,"
DB_TRANSFORM="s,^$LOCAL_PROJECT_ROOT_DIR/tmp,database,"

# Create temp directory
mkdir $LOCAL_TMP_DIR

# Dump the DB into the temp dir
mysqldump -u $LOCAL_DB_USER -p$LOCAL_DB_PASS $LOCAL_DB_NAME > $LOCAL_TMP_DIR/$LOCAL_DB_FILE

# Archive the site files; flatten the tree structure.
tar -cvf $LOCAL_TMP_DIR/$LOCAL_FILE -X $FILES_TO_EXCLUDE --transform $HTTPDOCS_TRANSFORM $LOCAL_HTTPDOCS_DIR

# Append it to the tarball; flatten the tree structure.
tar --append --file=$LOCAL_TMP_DIR/$LOCAL_FILE --transform $DB_TRANSFORM $LOCAL_TMP_DIR/$LOCAL_DB_FILE

# Compress the tarball
gzip -9 $LOCAL_TMP_DIR/$LOCAL_FILE

# Move out of tmp
mkdir $LOCAL_DESTINATION_DIR
mv $LOCAL_TMP_DIR/$LOCAL_FILE.gz $LOCAL_DESTINATION_DIR

# Clean up
rm $LOCAL_TMP_DIR/$LOCAL_DB_FILE
rm -rf $LOCAL_TMP_DIR