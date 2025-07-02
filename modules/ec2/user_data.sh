#!/bin/bash
yum update -y
amazon-linux-extras install -y php7.4
yum install -y httpd mysql

systemctl start httpd
systemctl enable httpd

cat <<EOF > /var/www/html/config.php
<?php
define('DB_SERVER', '${db_endpoint}');
define('DB_USERNAME', '${db_username}');
define('DB_PASSWORD', '${db_password}');
define('DB_NAME', '${db_name}');
?>
EOF

cat <<EOF > /var/www/html/index.php
<!DOCTYPE html>
<html>
<head>
    <title>Welcome</title>
</head>
<body>
    <h1>Welcome to ${env_prefix} environment</h1>
    <p>Connected to database at ${db_endpoint}</p>
    <?php phpinfo(); ?>
</body>
</html>
EOF

chown -R apache:apache /var/www/html
systemctl restart httpd
