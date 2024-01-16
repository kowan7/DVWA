#!/bin/bash

# Función para verificar el idioma y mostrar el mensaje correspondiente
get_language_message() {
    if [[ $LANG == *"es"* ]]; then
        echo -e "$1"
    else
        echo -e "$2"
    fi
}

# Verificar si el usuario es root
if [ "$EUID" -ne 0 ]; then
    error_message=$(get_language_message "\e[91mEste script debe ejecutarse como usuario root.\e[0m" "\e[91mThis script must be run by the root user.\e[0m")
    echo -e "$error_message"
    exit 1
fi

# Función para verificar la existencia de un programa
check_program() {
    command -v "$1" >/dev/null 2>&1 || {
        message=$(get_language_message "\033[91m$1 no está instalado. Instalándolo ahora..." "\033[91m$1 is not installed. Installing it now...")
        echo -e >&2 "$message"
        apt install -y "$1"
    }
}

# Arte ASCII
echo -e "\033[96m\033[1m
⠄⠄⠄⠄⠄⠄⠄⢀⣠⣶⣾⣿⣶⣦⣤⣀⠄⢀⣀⣤⣤⣤⣤⣄⠄⠄⠄⠄⠄⠄
⠄⠄⠄⠄⠄⢀⣴⣿⣿⣿⡿⠿⠿⠿⠿⢿⣷⡹⣿⣿⣿⣿⣿⣿⣷⠄⠄⠄⠄⠄
⠄⠄⠄⠄⠄⣾⣿⣿⣿⣯⣵⣾⣿⣿⡶⠦⠭⢁⠩⢭⣭⣵⣶⣶⡬⣄⣀⡀⠄⠄
⠄⠄⠄⡀⠘⠻⣿⣿⣿⣿⡿⠟⠩⠶⠚⠻⠟⠳⢶⣮⢫⣥⠶⠒⠒⠒⠒⠆⠐⠒
⠄⢠⣾⢇⣿⣿⣶⣦⢠⠰⡕⢤⠆⠄⠰⢠⢠⠄⠰⢠⠠⠄⡀⠄⢊⢯⠄⡅⠂⠄
⢠⣿⣿⣿⣿⣿⣿⣿⣏⠘⢼⠬⠆⠄⢘⠨⢐⠄⢘⠈⣼⡄⠄⠄⡢⡲⠄⠂⠠⠄
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣥⣀⡁⠄⠘⠘⠘⢀⣠⣾⣿⢿⣦⣁⠙⠃⠄⠃⠐⣀
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣋⣵⣾⣿⣿⣿⣿⣦⣀⣶⣾⣿⣿⡉⠉⠉
⣿⣿⣿⣿⣿⣿⣿⠟⣫⣥⣬⣭⣛⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡆⠄
⣿⣿⣿⣿⣿⣿⣿⠸⣿⣏⣙⠿⣿⣿⣶⣦⣍⣙⠿⠿⠿⠿⠿⠿⠿⠿⣛⣩⣶⠄
⣛⣛⣛⠿⠿⣿⣿⣿⣮⣙⠿⢿⣶⣶⣭⣭⣛⣛⣛⣛⠛⠛⠻⣛⣛⣛⣛⣋⠁⢀
⣿⣿⣿⣿⣿⣶⣬⢙⡻⠿⠿⣷⣤⣝⣛⣛⣛⣛⣛⣛⣛⣛⠛⠛⣛⣛⠛⣡⣴⣿
⣛⣛⠛⠛⠛⣛⡑⡿⢻⢻⠲⢆⢹⣿⣿⣿⣿⣿⣿⠿⠿⠟⡴⢻⢋⠻⣟⠈⠿⠿
⣿⡿⡿⣿⢷⢤⠄⡔⡘⣃⢃⢰⡦⡤⡤⢤⢤⢤⠒⠞⠳⢸⠃⡆⢸⠄⠟⠸⠛⢿
⡟⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠁⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⢸
\033[0m"

# Resto del script
welcome_message=$(get_language_message "\033[96mWelcome to the DVWA installer!\033[0m" "\033[96mBienvenido al instalador de DVWA!\033[0m")
echo -e "$welcome_message"

echo
echo
# Inicio del Script
update_message=$(get_language_message "\e[96mUpdating repositories...\e[0m" "\e[96mActualizando repositorios...\e[0m")
echo -e "$update_message"
apt update

dependencies_message=$(get_language_message "\e[96mVerifying and installing necessary dependencies...\e[0m" "\e[96mVerificando e instalando dependencias necesarias...\e[0m")
echo -e "$dependencies_message"

check_program apache2
check_program mariadb-server
check_program mariadb-client
check_program php
check_program php-mysqli
check_program php-gd
check_program libapache2-mod-php
check_program git

download_message=$(get_language_message "\e[96mDownloading DVWA from GitHub...\e[0m" "\e[96mDescargando DVWA desde GitHub...\e[0m")
echo -e "$download_message"
git clone https://github.com/digininja/DVWA.git /var/www/html/DVWA
sleep 2

mysql_start_message=$(get_language_message "\e[96mStarting MySQL...\e[0m" "\e[96mIniciando MySQL...\e[0m")
echo -e "$mysql_start_message"
systemctl start mysql.service
sleep 2

db_config_message=$(get_language_message "\e[96mConfiguring the database for DVWA...\e[0m" "\e[96mConfigurando la base de datos para DVWA...\e[0m")
echo -e "$db_config_message"
mysql -u root -e "CREATE DATABASE IF NOT EXISTS dvwa;"
mysql -u root -e "CREATE USER 'dvwa'@'localhost' IDENTIFIED BY 'abc123';"
mysql -u root -e "GRANT ALL PRIVILEGES ON dvwa.* TO 'dvwa'@'localhost';"
mysql -u root -e "FLUSH PRIVILEGES;"
sleep 2

dvwa_config_message=$(get_language_message "\e[96mConfiguring DVWA...\e[0m" "\e[96mConfigurando DVWA...\e[0m")
echo -e "$dvwa_config_message"
cp /var/www/html/DVWA/config/config.inc.php.dist /var/www/html/DVWA/config/config.inc.php
sed -i "s/\(\$_DVWA\[ 'db_password' \] = getenv('DVWA_DB_PASSWORD') ?: '\).*\('\)/\1abc123\2/" /var/www/html/DVWA/config/config.inc.php
sleep 2

permissions_config_message=$(get_language_message "\e[96mConfiguring permissions...\e[0m" "\e[96mConfigurando permisos...\e[0m")
echo -e "$permissions_config_message"
chown -R www-data:www-data /var/www/html/DVWA
chmod -R 755 /var/www/html/DVWA
sleep 2

php_config_message=$(get_language_message "\e[96mConfiguring PHP...\e[0m" "\e[96mConfigurando PHP...\e[0m")
echo -e "$php_config_message"
php_config_file="/etc/php/$(php -r 'echo PHP_MAJOR_VERSION . "." . PHP_MINOR_VERSION;')/apache2/php.ini"
sed -i 's/^\(allow_url_include =\).*/\1 on/' $php_config_file
sed -i 's/^\(allow_url_fopen =\).*/\1 on/' $php_config_file
sed -i 's/^\(display_errors =\).*/\1 on/' $php_config_file
sed -i 's/^\(display_startup_errors =\).*/\1 on/' $php_config_file
sleep 2

apache_restart_message=$(get_language_message "\e[96mRestarting Apache...\e[0m" "\e[96mReiniciando Apache...\e[0m")
echo -e "$apache_restart_message"
systemctl restart apache2
sleep 2

credentials_message=$(get_language_message "\e[92mUsername and password for the first use:\e[0m" "\e[92mUsuario y contraseña para el primer uso:\e[0m")
echo -e "$credentials_message"
echo -e "Username: \033[93mdvwa\033[0m"
echo -e "Password: \033[93mabc123\033[0m"

success_message=$(get_language_message "\e[92mDVWA has been installed successfully. Access \e[93mhttp://localhost/DVWA\e[0m to get started." "\e[92mDVWA se ha instalado correctamente. Accede a \e[93mhttp://localhost/DVWA\e[0m para comenzar.")
echo -e "$success_message"

credentials_after_setup_message=$(get_language_message "\e[92mCredentials after setup:\e[0m" "\e[92mCredenciales después de la configuración:\e[0m")
echo -e "$credentials_after_setup_message"
echo -e "Username: \033[93madmin\033[0m"
echo -e "Password: \033[93mpassword\033[0m"

echo
echo
echo -e "\033[91mCon ♡ by Iamcarron"
