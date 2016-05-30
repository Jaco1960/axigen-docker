# start the service
echo "Starting axigen service"
/etc/init.d/axigen start

echo "Starting..."
tail -F /var/log/dmesg