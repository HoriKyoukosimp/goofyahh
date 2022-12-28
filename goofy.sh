echo "welcome to auto build scripts made by @zutto_mayonaka_de_linoni on telegram"
echo "well this script isnt that good compared to revanced manager, revanced builder or revancify"
echo "this script is recommend for someone having issue using those builder"
echo "so have fun!"
echo "also subscribe to zutomayo on youtube or this script will kill itself (joking haha)"
echo "this script will start in 10 seconds..."
sleep 5
echo "5 second left..."
sleep 5
echo "LETSGOOOOOOOOOOOOOOOOOOOOOOOOOOOO"
rm -r -d rvxtemp
rm -r -d /sdcard/"revanced extended apks"
pkg update
termux-setup-storage
pkg i openjdk-17 -y
pkg i wget -y
pkg i jq -y
mkdir rvxtemp
mkdir .keystore
cd rvxtemp

clear

# create options.toml
touch options.toml
echo '[patch-options]' >> options.toml
echo 'YouTube_AppName = "ReVanced Extended"' >> options.toml
echo 'YouTube_PackageName = "app.rvx.android.youtube"' >> options.toml
echo 'Music_PackageName = "app.rvx.android.apps.youtube.music"' >> options.toml
echo 'Custom_Speed_Arrays = "0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0, 2.25"' >> options.toml
echo 'Overlay_Buttons_Icon = "new"' >> options.toml
echo 'darkThemeBackgroundColor = "@android:color/black"' >> options.toml

clear

echo "select app you want to patch"
echo "1 is youtube"
echo '2 is youtube music'
read patch

 download_additional_files() {
   # Set the repository owner, name, and the file name
ORG=inotia00
REPO1=revanced-patches
REPO2=revanced-cli
REPO3=revanced-integrations

# Get the URL of the file from the latest release
FILE_URL1=$(curl https://api.github.com/repos/$ORG/$REPO1/releases/latest | jq -r ".assets[] | select(.name | startswith(\"revanced-patches-\") and endswith(\".jar\")) | .browser_download_url")
FILE_URL2=$(curl https://api.github.com/repos/$ORG/$REPO2/releases/latest | jq -r ".assets[] | select(.name | startswith(\"revanced-cli-\") and endswith(\".jar\")) | .browser_download_url")
FILE_URL3=$(curl https://api.github.com/repos/$ORG/$REPO3/releases/latest | jq -r ".assets[] | select(.name | startswith(\"app-\") and endswith(\".apk\")) | .browser_download_url")
PATCH_JSON=$(curl https://api.github.com/repos/$ORG/$REPO1/releases/latest | jq -r ".assets[] | select(.name | startswith(\"patches-\") and endswith(\".json\")) | .browser_download_url")

echo "downloading required files for patching (around 60mb), it will automatically removed after finished patching"
# Download the files
curl -L $FILE_URL3 -o inte.apk -s
curl -L $FILE_URL2 -o revanced-cli.jar -s
curl -L $FILE_URL1 -o revanced-patches.jar -s
curl -OL https://github.com/HoriKyoukosimp/goofyahh/releases/download/aapt2/aapt2 -s
wget https://raw.githubusercontent.com/decipher3114/Revancify/main/revanced.keystore -P /data/data/com.termux/files/home/.keystore -nc -q
 }

if [ "$patch" -eq 1 ]; then
 # Prompt the user to enter the new values
 echo "Enter the new YouTube app name: "
 read app_name
 echo "Enter the new YouTube package name (have to be something like this: app.rvx.android.youtube or youtube.android.rvx (dont require youtube & android & rvx, it can be anything)): "
 read package_name

 clear

 # Use sed to update the options.json file
 sed -i "s/YouTube_AppName.*/YouTube_AppName = \"$app_name\"/" options.toml
 sed -i "s/YouTube_PackageName.*/YouTube_PackageName = \"$package_name\"/" options.toml
 
 echo "select youtube version"
 echo "1 is latest youtube version (beta included)"
 echo "2 is latest supported version by rvx"
 read ytver
  if [ "$ytver" -eq 1]; then
  WGET_HEADER="User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101 Firefox/102.0"

  #download youtube
  req() {
     wget -O "$2" --header="$WGET_HEADER" "$1"
   }

  get_latestytversion() {
      url="https://www.apkmirror.com/apk/google-inc/youtube/"
      YTVERSION=$(req "$url" - | grep "All version" -A200 | grep app_release | sed 's:.*/youtube-::g;s:-release/.*::g;s:-:.:g' | sort -r | head -1)
      echo "Latest Youtube Version: $YTVERSION"
 }

  dl_yt() {
      rm -rf $2
      echo "Downloading YouTube $1"
      url="https://www.apkmirror.com/apk/google-inc/youtube/youtube-${1//./-}-release/"
      url="$url$(req "$url" - | grep Variant -A50 | grep ">APK<" -A2 | grep android-apk-download | sed "s#.*-release/##g;s#/\#.*##g")"
      url="https://www.apkmirror.com$(req "$url" - | tr '\n' ' ' | sed -n 's;.*href="\(.*key=[^"]*\)">.*;\1;p')"
      url="https://www.apkmirror.com$(req "$url" - | tr '\n' ' ' | sed -n 's;.*href="\(.*key=[^"]*\)">.*;\1;p')"
      req "$url" "$2"
  }
 clear
  elif [ "$ytver" -eq 2]; then
  WGET_HEADER="User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101 Firefox/102.0"
  
   req() {
     wget -O "$2" --header="$WGET_HEADER" "$1"
   }

  get_latestytversion() {
      curl -L $PATCH_JSON -o patches.json -s
     YTVERSION=$(jq -r '.[] | select(.compatiblePackages[].name == "com.google.android.youtube") | .compatiblePackages[].versions | .[]' patches.json | sort -n | tail -1)
      echo "Latest Youtube Version: $YTVERSION"
 }

  dl_yt() {
      rm -rf $2
      echo "Downloading YouTube $1"
      url="https://www.apkmirror.com/apk/google-inc/youtube/youtube-${1//./-}-release/"
      url="$url$(req "$url" - | grep Variant -A50 | grep ">APK<" -A2 | grep android-apk-download | sed "s#.*-release/##g;s#/\#.*##g")"
      url="https://www.apkmirror.com$(req "$url" - | tr '\n' ' ' | sed -n 's;.*href="\(.*key=[^"]*\)">.*;\1;p')"
      url="https://www.apkmirror.com$(req "$url" - | tr '\n' ' ' | sed -n 's;.*href="\(.*key=[^"]*\)">.*;\1;p')"
      req "$url" "$2"
  }
  # Prompt the user to select a theme option
  clear
  echo "Select a theme option:"
  echo "1 is default"
  echo "2 is monet/material you"
  echo "3 is amoled"

  # Read the value of the numbers variable
  read numbers

   if [ "$numbers" -eq 1 ]; then
   clear
   # Prompt the user to select an icon color
    echo "Select an icon color:"
     echo "1 is red"
    echo "2 is blue"
    echo "3 is revancify"
    echo "4 is YouTube Original Icon"
   
    # Initialize the icon variable to an empty string
    icon=""
   
   
    # Start a while loop to prompt the user for input
    while [ -z "$icon" ] || [ "$icon" != "1" ] && [ "$icon" != "2" ] && [ "$icon" != "3" ]; do
     # Read the value of the icon variable
     read icon
     
     clear
     download_additional_files
     clear
     
     # Get the latest version of YouTube
       get_latestytversion

  # Check if the latest YouTube version was retrieved successfully
      if [ -z "$YTVERSION" ]; then
          echo "Error: Unable to retrieve latest YouTube version"
          exit 1
      fi

      # Download the latest version of YouTube
      dl_yt "$YTVERSION" "YouTube.apk"
 
      # Check if the YouTube app was downloaded successfully
      if [ ! -f "YouTube.apk" ]; then
          echo "Error: Unable to download YouTube app"
          exit 1
        fi
      clear
     # Modify the command string based on the value of the icon variable
     if [ -n "$icon" ]; then
       # If the icon is not blank, modify the command string based on the value of the icon variable
       if [ "$icon" == "1" ]; then
         # If the icon is "red", change custom-branding-any to "red"
         command="java -jar revanced-cli.jar -a YouTube.apk -c -b revanced-patches.jar --custom-aapt2-binary=/data/data/com.termux/files/home/rvxtemp/aapt2 --keystore /data/data/com.termux/files/home/.keystore/revanced.keystore -m inte.apk --experimental -o youtube_patched.apk -i custom-branding-name -i custom-branding-icon-afn-red -e custom-branding-icon-afn-blue -e custom-branding-icon-revancify"
       elif [ "$icon" == "2" ]; then
         # If the icon is "blue", change custom-branding-any to "blue"
         command="java -jar revanced-cli.jar -a YouTube.apk -c -b revanced-patches.jar --keystore /data/data/com.termux/files/home/.keystore/revanced.keystore -m inte.apk --experimental -o youtube_patched.apk -i custom-branding-name -i custom-branding-icon-afn-blue -e custom-branding-icon-revancify -e custom-branding-icon-afn-red --custom-aapt2-binary=/data/data/com.termux/files/home/rvxtemp/aapt2"
       elif [ "$icon" == "3" ]; then
         # If the icon is "revancify", change custom-branding-any to "revancify"
         command="java -jar revanced-cli.jar --keystore /data/data/com.termux/files/home/.keystore/revanced.keystore -a YouTube.apk -c -b revanced-patches.jar -m inte.apk --experimental -o youtube_patched.apk -i custom-branding-name -i custom-branding-icon-revancify -e custom-branding-icon-afn-blue -e custom-branding-icon-afn-red  --custom-aapt2-binary=/data/data/com.termux/files/home/rvxtemp/aapt2"
        elif [ "$icon" == "4" ]; then
         # If the icon is "revancify", change custom-branding-any to "og"
         command="java -jar revanced-cli.jar -a YouTube.apk -c -b revanced-patches.jar -m inte.apk --experimental --keystore /data/data/com.termux/files/home/.keystore/revanced.keystore -o youtube_patched.apk -i custom-branding-name -e custom-branding-icon-revancify -e custom-branding-icon-afn-blue -e custom-branding-icon-afn-red --custom-aapt2-binary=/data/data/com.termux/files/home/rvxtemp/aapt2"
       else
           # If the icon is something else, print an error message and set the icon variable to an empty string
           echo "Invalid icon color. Please try again."
           icon=""
     fi

   # Execute the modified command
   $command
   mkdir /sdcard/"revanced extended apks" && mv  youtube_patched.apk /sdcard/"revanced extended apks" && termux-open /sdcard/"revanced extended apks"/youtube_patched.apk
   fi
   done
   
  elif [ "$numbers" -eq 2 ]; then
  clear
   # Prompt the user to select an icon color
   echo "Select an icon color:"
   echo "1 is red"
   echo "2 is blue"
   echo "3 is revancify"
   echo "4 is YouTube Original Icon"
  
   # Initialize the icon variable to an empty string
   icon=""

   # Start a while loop to prompt the user for input
   while [ -z "$icon" ] || [ "$icon" != "1" ] && [ "$icon" != "2" ] && [ "$icon" != "3" ]; do
     # Read the value of the icon variable
     read icon
     
     clear
     download_additional_files
     clear
     
     # Get the latest version of YouTube
       get_latestytversion

  # Check if the latest YouTube version was retrieved successfully
      if [ -z "$YTVERSION" ]; then
          echo "Error: Unable to retrieve latest YouTube version"
          exit 1
      fi

      # Download the latest version of YouTube
      dl_yt "$YTVERSION" "YouTube.apk"
 
      # Check if the YouTube app was downloaded successfully
      if [ ! -f "YouTube.apk" ]; then
          echo "Error: Unable to download YouTube app"
          exit 1
        fi
      
   clear
  
     # Modify the command string based on the value of the icon variable
     if [ -n "$icon" ]; then
       # If the icon is not blank, modify the command string based on the value of the icon variable
       if [ "$icon" == "1" ]; then
           # If the icon is "red", change custom-branding-any to "red"
         command="java -jar revanced-cli.jar -a YouTube.apk -c -b revanced-patches.jar -m inte.apk -i materialyou -e theme --experimental -o youtube_patched.apk -i custom-branding-name -i custom-branding-icon-afn-red -e custom-branding-icon-afn-blue -e custom-branding-icon-revancify --keystore /data/data/com.termux/files/home/.keystore/revanced.keystore --custom-aapt2-binary=/data/data/com.termux/files/home/rvxtemp/aapt2"
       elif [ "$icon" == "2" ]; then
         # If the icon is "blue", change custom-branding-any to "blue"
         command="java -jar revanced-cli.jar -a YouTube.apk -c -b revanced-patches.jar -m inte.apk -i materialyou -e theme --experimental -o youtube_patched.apk -i custom-branding-name -i custom-branding-icon-afn-blue -e custom-branding-icon-afn-red -e custom-branding-icon-revancify --custom-aapt2-binary=/data/data/com.termux/files/home/rvxtemp/aapt2 --keystore /data/data/com.termux/files/home/.keystore/revanced.keystore"
       elif [ "$icon" == "3" ]; then
         # If the icon is "revancify", change custom-branding-any to "revancify"
         command="java -jar revanced-cli.jar -a YouTube.apk -c -b revanced-patches.jar -m inte.apk -i materialyou -e theme --experimental -o youtube_patched.apk -i custom-branding-name -i custom-branding-icon-revancify -e custom-branding-icon-afn-blue -e custom-branding-icon-afn-red --custom-aapt2-binary=/data/data/com.termux/files/home/rvxtemp/aapt2 --keystore /data/data/com.termux/files/home/.keystore/revanced.keystore"
        elif [ "$icon" == "4" ]; then
         # If the icon is "revancify", change custom-branding-any to "og"
         command="java -jar revanced-cli.jar -a YouTube.apk -c -b revanced-patches.jar -m inte.apk -i materialyou -e theme --experimental --keystore /data/data/com.termux/files/home/.keystore/revanced.keystore -o youtube_patched.apk -i custom-branding-name -e custom-branding-icon-revancify -e custom-branding-icon-afn-blue -e custom-branding-icon-afn-red --custom-aapt2-binary=/data/data/com.termux/files/home/rvxtemp/aapt2"
       else
         # If the icon is something else, print an error message and set the icon variable to an empty string
         echo "Invalid icon color. Please try again."
         icon=""
       fi
   # Execute the modified command
   $command
   mkdir /sdcard/"revanced extended apks" && mv  youtube_patched.apk /sdcard/"revanced extended apks" && termux-open /sdcard/"revanced extended apks"/youtube_patched.apk
    else
     # If the user enters an invalid option, print an error message and exit the script
     echo "Invalid option. Exiting script."
     exit 1
   fi 
   done
   
  elif [ "$numbers" -eq 3 ]; then
  clear
   # Prompt the user to select an icon color
   echo "Select an icon color:"
   echo "1 is red"
   echo "2 is blue"
   echo "3 is revancify"
   echo "4 is YouTube Original Icon"
  
   # Initialize the icon variable to an empty string
   icon=""

   # Start a while loop to prompt the user for input
   while [ -z "$icon" ] || [ "$icon" != "1" ] && [ "$icon" != "2" ] && [ "$icon" != "3" ]; do
     # Read the value of the icon variable
     read icon
     
     clear
     download_additional_files
     clear
     # Get the latest version of YouTube
       get_latestytversion

  # Check if the latest YouTube version was retrieved successfully
      if [ -z "$YTVERSION" ]; then
          echo "Error: Unable to retrieve latest YouTube version"
          exit 1
      fi

      # Download the latest version of YouTube
      dl_yt "$YTVERSION" "YouTube.apk"
 
      # Check if the YouTube app was downloaded successfully
      if [ ! -f "YouTube.apk" ]; then
          echo "Error: Unable to download YouTube app"
          exit 1
        fi
      
   clear
  
     # Modify the command string based on the value of the icon variable
     if [ -n "$icon" ]; then
       # If the icon is not blank, modify the command string based on the value of the icon variable
       if [ "$icon" == "1" ]; then
         # If the icon is "red", change custom-branding-any to "red"
         command="java -jar revanced-cli.jar -a YouTube.apk -c -b revanced-patches.jar -m inte.apk --experimental -o youtube_patched.apk -i custom-branding-name -i custom-branding-icon-afn-red -e custom-branding-icon-afn-blue -e custom-branding-icon-revancify --custom-aapt2-binary=/data/data/com.termux/files/home/rvxtemp/aapt2 --keystore /data/data/com.termux/files/home/.keystore/revanced.keystore"
       elif [ "$icon" == "2" ]; then
         # If the icon is "blue", change custom-branding-any to "blue"
         command="java -jar revanced-cli.jar --keystore /data/data/com.termux/files/home/.keystore/revanced.keystore -a YouTube.apk -c -b revanced-patches.jar -m inte.apk --experimental -o youtube_patched.apk -i custom-branding-name -i custom-branding-icon-afn-blue -e custom-branding-icon-revancify -e custom-branding-icon-afn-red --custom-aapt2-binary=/data/data/com.termux/files/home/rvxtemp/aapt2"
       elif [ "$icon" == "3" ]; then
         # If the icon is "revancify", change custom-branding-any to "revancify"
         command="java -jar revanced-cli.jar -a YouTube.apk -c -b revanced-patches.jar -m inte.apk --experimental --keystore /data/data/com.termux/files/home/.keystore/revanced.keystore -o youtube_patched.apk -i custom-branding-name -i custom-branding-icon-revancify -e custom-branding-icon-afn-blue -e custom-branding-icon-afn-red --custom-aapt2-binary=/data/data/com.termux/files/home/rvxtemp/aapt2"
       elif [ "$icon" == "4" ]; then
         # If the icon is "revancify", change custom-branding-any to "og"
         command="java -jar revanced-cli.jar -a YouTube.apk -c -b revanced-patches.jar -m inte.apk --experimental --keystore /data/data/com.termux/files/home/.keystore/revanced.keystore -o youtube_patched.apk -i custom-branding-name -e custom-branding-icon-revancify -e custom-branding-icon-afn-blue -e custom-branding-icon-afn-red --custom-aapt2-binary=/data/data/com.termux/files/home/rvxtemp/aapt2"
       else
         # If the icon is something else, print an error message and set the icon variable to an empty string
         echo "Invalid icon color. Please try again."
         icon=""
     fi
    # Execute the modified command
    $command
    mkdir /sdcard/"revanced extended apks" && mv  youtube_patched.apk /sdcard/"revanced extended apks" && termux-open /sdcard/"revanced extended apks"/youtube_patched.apk
     else
     # If the user enters an invalid option, print an error message and exit the script
     echo "Invalid option. Exiting script."
     exit 1
   fi
   done 

   elif [ "$numbers" -eq 4 ]; then
   clear
   # Prompt the user to select an icon color
   echo "Select an icon color:"
   echo "1 is red"
   echo "2 is blue"
   echo "3 is revancify"
   echo "4 is YouTube Original Icon"
   
   # Initialize the icon variable to an empty string
   icon=""

   # Start a while loop to prompt the user for input
   while [ -z "$icon" ] || [ "$icon" != "1" ] && [ "$icon" != "2" ] && [ "$icon" != "3" ]; do
     # Read the value of the icon variable
     read icon
     
     clear
     download_additional_files
     clear

     
     # Get the latest version of YouTube
       get_latestytversion

  # Check if the latest YouTube version was retrieved successfully
      if [ -z "$YTVERSION" ]; then
          echo "Error: Unable to retrieve latest YouTube version"
          exit 1
      fi

      # Download the latest version of YouTube
      dl_yt "$YTVERSION" "YouTube.apk"
 
      # Check if the YouTube app was downloaded successfully
      if [ ! -f "YouTube.apk" ]; then
          echo "Error: Unable to download YouTube app"
          exit 1
        fi
      
  clear

     # Modify the command string based on the value of the icon variable
     if [ -n "$icon" ]; then
       # If the icon is not blank, modify the command string based on the value of the icon variable
       if [ "$icon" == "1" ]; then
         # If the icon is "red", change custom-branding-any to "red"
         command="java -jar revanced-cli.jar -a YouTube.apk -c -b revanced-patches.jar -m inte.apk --experimental -o youtube_patched.apk -i theme -i materialyou -i custom-branding-name -i custom-branding-icon-afn-red -e custom-branding-icon-afn-blue -e custom-branding-icon-revancify --custom-aapt2-binary=/data/data/com.termux/files/home/rvxtemp/aapt2 --keystore /data/data/com.termux/files/home/.keystore/revanced.keystore"
       elif [ "$icon" == "2" ]; then
         # If the icon is "blue", change custom-branding-any to "blue"
         command="java -jar revanced-cli.jar --keystore /data/data/com.termux/files/home/.keystore/revanced.keystore -a YouTube.apk -c -b revanced-patches.jar -i theme -i materialyou -m inte.apk --experimental -o youtube_patched.apk -i custom-branding-name -i custom-branding-icon-afn-blue -e custom-branding-icon-revancify -e custom-branding-icon-afn-red --custom-aapt2-binary=/data/data/com.termux/files/home/rvxtemp/aapt2"
       elif [ "$icon" == "3" ]; then
         # If the icon is "revancify", change custom-branding-any to "revancify"
         command="java -jar revanced-cli.jar -a YouTube.apk -c -b revanced-patches.jar -m inte.apk --experimental --keystore /data/data/com.termux/files/home/.keystore/revanced.keystore -i theme -i materialyou -o youtube_patched.apk -i custom-branding-name -i custom-branding-icon-revancify -e custom-branding-icon-afn-red -e custom-branding-icon-afn-blue --custom-aapt2-binary=/data/data/com.termux/files/home/rvxtemp/aapt2"
       elif [ "$icon" == "4" ]; then
         # If the icon is "revancify", change custom-branding-any to "og"
         command="java -jar revanced-cli.jar -a YouTube.apk -c -b revanced-patches.jar -m inte.apk --experimental --keystore /data/data/com.termux/files/home/.keystore/revanced.keystore -i theme -i materialyou -o youtube_patched.apk -i custom-branding-name -e custom-branding-icon-revancify -e custom-branding-icon-afn-blue -e custom-branding-icon-afn-red --custom-aapt2-binary=/data/data/com.termux/files/home/rvxtemp/aapt2"
       else
         # If the icon is something else, print an error message and set the icon variable to an empty string
         echo "Invalid icon color. Please try again."
         icon=""
     fi
    # Execute the modified command
    $command
    mkdir /sdcard/"revanced extended apks" && mv  youtube_patched.apk /sdcard/"revanced extended apks" && termux-open /sdcard/"revanced extended apks"/youtube_patched.apk
     else
     # If the user enters an invalid option, print an error message and exit the script
     echo "Invalid option. Exiting script."
     exit 1
   fi
   done 
 fi
elif [ "$patch" -eq 2 ]; then

  echo "unable to change youtube music app name (limitation for now)"
  echo "Enter the new YouTube package name (have to be something like this: app.rvx.android.youtube or youtube.android.rvx (dont require youtube & android & rvx, it can be anything)): "
  read package_name

  

  # Use sed to update the options.json file
  sed -i "s/Music_PackageName.*/Music_PackageName = \"$package_name\"/" options.toml
  #download youtube music
 WGET_HEADER="User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101 Firefox/102.0"
 req() {
     wget -q -O "$2" --header="$WGET_HEADER" "$1"
 }

 get_latestytmversion() {
    url="https://www.apkmirror.com/apk/google-inc/youtube-music/"
    YTMVERSION=$(req "$url" - | grep "All version" -A200 | grep app_release | sed 's:.*/youtube-music-::g;s:-release/.*::g;s:-:.:g' | sort -r | head -1)
    echo "Latest YoutubeMusic Version: $YTMVERSION"
 }


 dl_ytm() {
    rm -rf $2
    echo "Downloading YouTube Music $1"
    echo "dont worry, tHe script is still running"
    echo "i just dont know how to make req show progress"
    url="https://www.apkmirror.com/apk/google-inc/youtube-music/youtube-music-${1//./-}-release/"
    url="$url$(req "$url" - | grep arm64 -A30 | grep youtube-music | head -1 | sed "s#.*-release/##g;s#/\".*##g")"
    url="https://www.apkmirror.com$(req "$url" - | tr '\n' ' ' | sed -n 's;.*href="\(.*key=[^"]*\)">.*;\1;p')"
    url="https://www.apkmirror.com$(req "$url" - | tr '\n' ' ' | sed -n 's;.*href="\(.*key=[^"]*\)">.*;\1;p')"
    req "$url" "$2"
 }

   clear
   echo "Select an icon color:"
   echo "1 is red"
   echo "2 is revancify"
   echo "3 is YouTube Original Icon"
   # Initialize the icon variable to an empty string
   icon=""
   
   
   
   # Start a while loop to prompt the user for input
   while [ -z "$icon" ] || [ "$icon" != "1" ] && [ "$icon" != "2" ] && [ "$icon" != "3" ]; do
     # Read the value of the icon variable
     read icon
     
     clear
     download_additional_files
     clear
  # Get the latest version of YouTube music
  
      get_latestytmversion
 
      # Check if the latest YouTube version was retrieved successfully
      if [ -z "$YTMVERSION" ]; then
          echo "Error: Unable to retrieve latest YouTube music version"
          exit 1
      fi

      # Download the latest version of YouTube music
       dl_ytm "$YTMVERSION" "YouTube_Music.apk"
 
      # Check if the YouTube app was downloaded successfully
      if [ ! -f "YouTube_Music.apk" ]; then
          echo "Error: Unable to download YouTube music app"
          exit 1
      fi
     clear
     # Modify the command string based on the value of the icon variable
     if [ -n "$icon" ]; then
       # If the icon is not blank, modify the command string based on the value of the icon variable
       if [ "$icon" == "1" ]; then
         # If the icon is "red", change custom-branding-any to "red"
         command="java -jar revanced-cli.jar -a YouTube_Music.apk -c -b revanced-patches.jar --custom-aapt2-binary=/data/data/com.termux/files/home/rvxtemp/aapt2 --keystore /data/data/com.termux/files/home/.keystore/revanced.keystore -m inte.apk --experimental -o youtube_music_patched.apk -i custom-branding-name -i custom-branding-icon-music-red "
       elif [ "$icon" == "2" ]; then
         # If the icon is "revancify", change custom-branding-any to "revancify"
         command="java -jar revanced-cli.jar --keystore /data/data/com.termux/files/home/.keystore/revanced.keystore -a YouTube_Music.apk -c -b revanced-patches.jar -m inte.apk --experimental -o youtube_music_patched.apk -i custom-branding-name -i custom-branding-icon-revancify --custom-aapt2-binary=/data/data/com.termux/files/home/rvxtemp/aapt2"
        elif [ "$icon" == "3" ]; then
         # If the icon is "revancify", change custom-branding-any to "og"
         command="java -jar revanced-cli.jar -a YouTube_Music.apk -c -b revanced-patches.jar -m inte.apk --experimental --keystore /data/data/com.termux/files/home/.keystore/revanced.keystore -o youtube_music_patched.apk -i custom-branding-name -e custom-branding-icon-revancify -e custom-branding-icon-afn-blue -e custom-branding-icon-afn-red --custom-aapt2-binary=/data/data/com.termux/files/home/rvxtemp/aapt2"
       else
           # If the icon is something else, print an error message and set the icon variable to an empty string
           echo "Invalid icon color. Please try again."
           icon=""
     fi

   # Execute the modified command
   $command
   mkdir /sdcard/"revanced extended apks" && mv  youtube_music_patched.apk /sdcard/"revanced extended apks" && termux-open /sdcard/"revanced extended apks"/youtube_music_patched.apk
   fi
 done
else
  echo "Invalid input. Exiting the script..."
  exit 1
  fi
cd || exit
rm -r -d rvxtemp

clear
echo "thanks for using my script! hope you have fun with revanced extended!"
echo "if for whatever reason the package installer didnt pop up, u can go to your file manager app, u will see folder named "revanced extended apks" install the apk from there"