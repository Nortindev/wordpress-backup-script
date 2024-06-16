#!/bin/bash

backup_site() {
  local site_path=$1
  local backup_name=$2

  echo "Creating backup for $site_path"
  tar -cvzf "$backup_name" -C "$site_path" public_html
}

backup_database() {
  local db_name=$1
  local db_user=$2
  local db_pass=$3
  local backup_name=$4

  echo "Creating database backup for $db_name"
  mysqldump -u"$db_user" -p"$db_pass" "$db_name" > "$backup_name"
}

scan_directory() {
  local directory=$1

  echo "Scanning directory: $directory"
  wp_config="$directory/public_html/wp-config.php"
  if [ -f "$wp_config" ]; then
    db_name=$(awk -F "'" '/DB_NAME/ {print $4}' "$wp_config")
    db_user=$(awk -F "'" '/DB_USER/ {print $4}' "$wp_config")
    db_pass=$(awk -F "'" '/DB_PASSWORD/ {print $4}' "$wp_config")

    if [ -n "$db_name" ] && [ -n "$db_user" ] && [ -n "$db_pass" ]; then
      site_name=$(basename "$directory")
      backup_site "$directory" "${site_name}_sitebackup.tar.gz"
      backup_database "$db_name" "$db_user" "$db_pass" "${site_name}_database.sql"
    else
      echo "Could not extract database details for $directory"
    fi
  else
    echo "No wp-config.php found in $directory"
  fi
}

echo "Select an option:"
echo "1. Main domains"
echo "2. Subdomains"
read option

if [ "$option" == "1" ]; then
  echo "Enter the domain name:"
  read domain
  scan_directory "/home/$USER/domains/$domain"
elif [ "$option" == "2" ]; then
  echo "Enter main domain name:"
  read main_domain
  for subdomain in $(find /home/"$USER"/domains/"$main_domain"/public_html -maxdepth 1 -type d | tail -n +2); do
    scan_directory "$subdomain"
  done
else
  echo "Usage: scriptfinal.sh [1|2]"
fi

