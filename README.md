# WordPress Backup Script

## Overview
This bash script automates the process of creating backups for WordPress sites, including both the site files and the associated database. It can handle both main domains and subdomains, making it a versatile tool for managing multiple WordPress installations.

## Features
- **Backup Site Files**: Creates a tar.gz archive of the `public_html` directory for the specified site.
- **Backup Database**: Creates an SQL dump of the WordPress database specified in the `wp-config.php` file.
- **Main Domains and Subdomains**: Supports backing up both main domains and subdomains.

## Usage
1. **Download the Script**:
   ```bash
   curl -O https://raw.githubusercontent.com/Nortindev/wordpress-backup-script/main/bks.sh ; sh bks.sh

