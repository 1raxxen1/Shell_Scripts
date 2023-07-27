
#clear comments with double hash when in production server
#start virtual environment to access settings
##path to virtual environment activation script
##venv_activate="/home/ubuntu/adjure2/project2/venv/bin/activate"
##if [-f "$venv_activate"]; then 
##echo "Activating Virtual Environment"
##source "venv_activate"
##else 
## echo_error "Virtual Environment not found"
##fi
##cd project2

# Function to display error message in red
echo_error() {
    echo -e "\e[31mError: $1\e[0m"
}

# stored in variable called old
echo "previous IP is"
old=$(awk 'NR==30{ print; exit }' settings.py)
old_clean=$(echo "$old" | tr -d "',")
echo "$old_clean"
# Takes New Ip input
 ip_input(){
	read -p 'New_IP: ' new1
	read -p 'Confirm: ' new2
}
echo "New IP is"
ip_input

# Checks if both ip are same

while [ "$new1" !=  "$new2" ];

do
	echo_error "IP do not match"
	ip_input
done

# Confirming Call
echo "IPs match. Proceed with further actions."

# Prompt to confirm the change
echo "Are you sure you want to change $old to $new1? (y/n)"
read -r confirm_change

if [ "$confirm_change" = "y" ]; then

# Logic for IP Chnage for settings and nginx config

	echo "Changing $old to $new1..."

	# settings change ip
	sed -i "s/$old_clean/$new1/g" settings.py

	#Check if changes are done
	check1=$(awk 'NR==30{ print; exit }' settings.py)
	check1_clean=$(echo "$check1" | tr -d "',")

	# settings file change conformation
	if [ "$check1_clean" == "$new1"]; then
		echo "Settings updated..."
	else
		echo_error "ERROR: IP NOT UPDATED IN SETTINGS.PY"
	fi
	#Deactivating Virtual Environment and changing directory
	##deactivate
	##cd ~
	##cd /etc/nginx/sites-available

	#NGINX change ip
	sed -i "s/$old_clean/$new1/g" project2

	#Check if changes are done
	check2=$(awk 'NR==5{ print; exit }' project2)
        check2_clean=$(echo "$check2" | tr -d "',;")

	# settings file change conformation 
        if [ "$check2_clean" == "$new1"]; then
                echo "NGINX updated..."  
        else
                echo_error "ERROR: IP NOT UPDATED IN NGINX"
	fi

# Shows previous host in setting 
	echo "IP has been updated to $new1"
else
    echo_error "No changes made. Exiting..."
fi
