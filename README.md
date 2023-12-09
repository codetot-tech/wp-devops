# WordPress Maintenance Bash Script

## On this repository

- `scripts/maintenance.sh` - a main script
- `.htaccess` - the sample rule to set 401 when accessing folder /scripts/

## Installation

```bash
# Navigate to WordPress project
cd public_html

# Create a folder scripts
mkdir scripts

# Download a raw bash script file
wget https://raw.githubusercontent.com/codetot-tech/wp-devops/main/scripts/maintenance.sh

# CHMOD execute permission
chmod +x ./scripts/maintenance.sh
```

### (Optional, for htaccess support environment)

```bash
# Download current .htaccess
wget https://raw.githubusercontent.com/codetot-tech/wp-devops/main/.htaccess htaccess.txt

# Append to last line
sed -i '$r htaccess.txt' .htaccess

# Remove file
rm -rf htaccess.txt
```

## Run a script

```bash
# Navigate to WordPress project
cd public_html

# Run a script
./scripts/maintenance.sh
```

## Why do you love this script?

- **Faster Workflows:** Automate repetitive tasks like database backups, theme and plugin updates, freeing up your valuable time for more important things.
- **Reduced Errors:** By automating tasks with proven scripts, you eliminate human error and ensure your maintenance is performed correctly every time.
- **Easy Code Management:** With Git integration, you can track changes to your maintenance script, collaborate with others, and easily roll back to previous versions if needed.
- **Simple to Use:** This script is designed to be easy to use, even if you're not a seasoned programmer. Just running and see a report.
- **Highly Customizable:** Tailor the script to your specific needs and preferences, allowing you to automate the maintenance tasks you need most.
