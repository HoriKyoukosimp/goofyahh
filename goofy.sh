echo "welcome to auto build scripts made by @fame_iplaytouhou on telegram"
echo "well this script isnt that good compared to revanced manager, revanced builder or revancify"
echo "this script is recommend for someone having issue using those builder"
echo "so have fun!"
echo "also subscribe to zutomayo on youtube or this script will kill itself (joking haha)"
echo "this script will start in 5 seconds..."
sleep 1
echo "4..."
sleep 1
echo "3..."
sleep 1
echo "2..."
sleep 1
echo "1..."
sleep 1

rm -r -d rvxtemp
rm -r -d /sdcard/"revanced extended apks"
pkg update
pkg i openjdk-17 -y
pkg i jq -y
pkg i wget -y
pkg i aria2 -y
mkdir rvxtemp
mkdir .keystore
cd rvxtemp || exit

clear

patchiconred="java -jar revanced-cli.jar -a YouTube.apk -c -b revanced-patches.jar -m inte.apk --experimental -o youtube_patched.apk -i custom-branding-name -i custom-branding-icon-afn-red -e custom-branding-icon-afn-blue -e custom-branding-icon-revancify --keystore /data/data/com.termux/files/home/.keystore/revanced.keystore --custom-aapt2-binary=/data/data/com.termux/files/home/rvxtemp/aapt2"
patchiconblue="java -jar revanced-cli.jar -a YouTube.apk -c -b revanced-patches.jar --keystore /data/data/com.termux/files/home/.keystore/revanced.keystore -m inte.apk --experimental -o youtube_patched.apk -i custom-branding-name -i custom-branding-icon-afn-blue -e custom-branding-icon-revancify -e custom-branding-icon-afn-red --custom-aapt2-binary=/data/data/com.termux/files/home/rvxtemp/aapt2"
patchiconrevancify="java -jar revanced-cli.jar --keystore /data/data/com.termux/files/home/.keystore/revanced.keystore -a YouTube.apk -c -b revanced-patches.jar -m inte.apk --experimental -o youtube_patched.apk -i custom-branding-name -i custom-branding-icon-revancify -e custom-branding-icon-afn-blue -e custom-branding-icon-afn-red  --custom-aapt2-binary=/data/data/com.termux/files/home/rvxtemp/aapt2"
patchiconog="java -jar revanced-cli.jar -a YouTube.apk -c -b revanced-patches.jar -m inte.apk --experimental --keystore /data/data/com.termux/files/home/.keystore/revanced.keystore -o youtube_patched.apk -i custom-branding-name -e custom-branding-icon-revancify -e custom-branding-icon-afn-blue -e custom-branding-icon-afn-red --custom-aapt2-binary=/data/data/com.termux/files/home/rvxtemp/aapt2"

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
echo "select variants"
echo "1 is non root (recommend)"
echo "2 is root"
read var
if [ "$var" -eq 1 ]; then
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
 PATCH_JSON=$(curl https://api.github.com/repos/$ORG/$REPO1/releases/latest | jq -r ".assets[] | select(.name | startswith(\"patches\") and endswith(\".json\")) | .browser_download_url")

 echo "downloading required files for patching (around 60mb), it will automatically removed after finished patching"
 # Download the files
 aria2c -x 8 -s 8 -k 1M -o inte.apk "$FILE_URL3"
 aria2c -x 8 -s 8 -k 1M -o revanced-cli.jar "$FILE_URL2"
 aria2c -x 8 -s 8 -k 1M -o revanced-patches.jar "$FILE_URL1"
 aria2c -x 8 -s 8 -k 1M -o aapt2 https://github.com/HoriKyoukosimp/goofyahh/releases/download/aapt2/aapt2
 aria2c -x 8 -s 8 -k 1M -o /data/data/com.termux/files/home/.keystore/revanced.keystore https://raw.githubusercontent.com/decipher3114/Revancify/main/revanced.keystore --allow-overwrite=false

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
  if [ "$ytver" -eq 1 ]; then
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
      rm -rf "$2"
      echo "Downloading YouTube $1"
      url="https://www.apkmirror.com/apk/google-inc/youtube/youtube-${1//./-}-release/"
      url="$url$(req "$url" - | grep Variant -A50 | grep ">APK<" -A2 | grep android-apk-download | sed "s#.*-release/##g;s#/\#.*##g")"
      url="https://www.apkmirror.com$(req "$url" - | tr '\n' ' ' | sed -n 's;.*href="\(.*key=[^"]*\)">.*;\1;p')"
      url="https://www.apkmirror.com$(req "$url" - | tr '\n' ' ' | sed -n 's;.*href="\(.*key=[^"]*\)">.*;\1;p')"
      req "$url" "$2"
  }
  elif [ "$ytver" -eq 2 ]; then
   WGET_HEADER="User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101 Firefox/102.0"

   #download youtube
    req() {
      wget -O "$2" --header="$WGET_HEADER" "$1"
    }

   get_latestytversion() {
      curl -L "$PATCH_JSON" -o patches.json 
     YTVERSION=$(jq -r '.[] | select(.compatiblePackages[].name == "com.google.android.youtube") | .compatiblePackages[].versions | .[]' patches.json | sort -n | tail -1)
      echo "Latest Youtube Version: $YTVERSION"
 }

   dl_yt() {
      rm -rf "$2"
      echo "Downloading YouTube $1"
      url="https://www.apkmirror.com/apk/google-inc/youtube/youtube-${1//./-}-release/"
      url="$url$(req "$url" - | grep Variant -A50 | grep ">APK<" -A2 | grep android-apk-download | sed "s#.*-release/##g;s#/\#.*##g")"
      url="https://www.apkmirror.com$(req "$url" - | tr '\n' ' ' | sed -n 's;.*href="\(.*key=[^"]*\)">.*;\1;p')"
      url="https://www.apkmirror.com$(req "$url" - | tr '\n' ' ' | sed -n 's;.*href="\(.*key=[^"]*\)">.*;\1;p')"
      req "$url" "$2"
  }
  fi
  # Prompt the user to select a theme option
  clear
  echo "Select a theme option:"
  echo "1 is default"
  echo "2 is monet/material you"
  echo "3 is amoled"
  echo "4 is amoled + monet/material you"

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
         command="$patchiconred -e theme -e materialyou"
       elif [ "$icon" == "2" ]; then
         # If the icon is "blue", change custom-branding-any to "blue"
         command="$patchiconblue -e theme -e materialyou"
       elif [ "$icon" == "3" ]; then
         # If the icon is "revancify", change custom-branding-any to "revancify"
         command="$patchiconrevancify -e theme -e materialyou"
        elif [ "$icon" == "4" ]; then
         # If the icon is "revancify", change custom-branding-any to "og"
         command="$patchiconog -e theme -e materialyou"
       else
           # If the icon is something else, print an error message and set the icon variable to an empty string
           echo "Invalid icon color. Please try again."
           icon=""
     fi

   # Execute the modified command
   $command
   mkdir /sdcard/"revanced extended apks" && mv  youtube_patched.apk /sdcard/"revanced extended apks" && termux-open /sdcard/"revanced extended apks"/youtube_patched.apk
   cd || exit
    rm -r -d rvxtemp

    clear
    echo "thanks for using my script! hope you have fun with revanced extended!"
    echo "if for whatever reason the package installer didnt pop up, u can go to your file manager app, u will see folder named "revanced extended apks" install the apk from there"
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
         command="$patchiconred -e theme -i materialyou"
       elif [ "$icon" == "2" ]; then
         # If the icon is "blue", change custom-branding-any to "blue"
         command="$patchiconblue -e theme -i materialyou"
       elif [ "$icon" == "3" ]; then
         # If the icon is "revancify", change custom-branding-any to "revancify"
         command="$patchiconrevancify -e theme -i materialyou"
        elif [ "$icon" == "4" ]; then
         # If the icon is "revancify", change custom-branding-any to "og"
         command="$patchiconog -e theme -i materialyou"   
        else
         # If the icon is something else, print an error message and set the icon variable to an empty string
         echo "Invalid icon color. Please try again."
         icon=""
       fi
   # Execute the modified command
   $command
   mkdir /sdcard/"revanced extended apks" && mv  youtube_patched.apk /sdcard/"revanced extended apks" && termux-open /sdcard/"revanced extended apks"/youtube_patched.apk
   cd || exit
    rm -r -d rvxtemp

    clear
    echo "thanks for using my script! hope you have fun with revanced extended!"
    echo "if for whatever reason the package installer didnt pop up, u can go to your file manager app, u will see folder named "revanced extended apks" install the apk from there"
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
         command="$patchiconred -i theme -e materialyou"
       elif [ "$icon" == "2" ]; then
         # If the icon is "blue", change custom-branding-any to "blue"
         command="$patchiconblue -i theme -e materialyou"
       elif [ "$icon" == "3" ]; then
         # If the icon is "revancify", change custom-branding-any to "revancify"
         command="$patchiconrevancify -i theme -e materialyou"
        elif [ "$icon" == "4" ]; then
         # If the icon is "revancify", change custom-branding-any to "og"
         command="$patchiconog -i theme -e materialyou"
        else
         # If the icon is something else, print an error message and set the icon variable to an empty string
         echo "Invalid icon color. Please try again."
         icon=""
     fi
    # Execute the modified command
    $command
    mkdir /sdcard/"revanced extended apks" && mv  youtube_patched.apk /sdcard/"revanced extended apks" && termux-open /sdcard/"revanced extended apks"/youtube_patched.apk
    cd || exit
    rm -r -d rvxtemp

    clear
    echo "thanks for using my script! hope you have fun with revanced extended!"
    echo "if for whatever reason the package installer didnt pop up, u can go to your file manager app, u will see folder named "revanced extended apks" install the apk from there"
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
         command="$patchiconred -i theme -i materialyou"
       elif [ "$icon" == "2" ]; then
         # If the icon is "blue", change custom-branding-any to "blue"
         command="$patchiconblue -i theme -i materialyou"
       elif [ "$icon" == "3" ]; then
         # If the icon is "revancify", change custom-branding-any to "revancify"
         command="$patchiconrevancify -i theme -i materialyou"
        elif [ "$icon" == "4" ]; then
         # If the icon is "revancify", change custom-branding-any to "og"
         command="$patchiconog -i theme -i materialyou"
       else
         # If the icon is something else, print an error message and set the icon variable to an empty string
         echo "Invalid icon color. Please try again."
         icon=""
     fi
    # Execute the modified command
    $command
    mkdir /sdcard/"revanced extended apks" && mv  youtube_patched.apk /sdcard/"revanced extended apks" && termux-open /sdcard/"revanced extended apks"/youtube_patched.apk
    cd || exit
    rm -r -d rvxtemp

    clear
    echo "thanks for using my script! hope you have fun with revanced extended!"
    echo "if for whatever reason the package installer didnt pop up, u can go to your file manager app, u will see folder named "revanced extended apks" install the apk from there"
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

   #download youtube
    req() {
      wget -O "$2" --header="$WGET_HEADER" "$1"
    }
  get_latestytmversion() {
    url="https://www.apkmirror.com/apk/google-inc/youtube-music/"
    YTMVERSION=$(req "$url" - | grep "All version" -A200 | grep app_release | sed 's:.*/youtube-music-::g;s:-release/.*::g;s:-:.:g' | sort -r | head -1)
    echo "Latest Youtube Music Version: $YTMVERSION"
  }


  dl_ytm() {
    rm -rf "$2"
    echo "Downloading YouTube Music $1"
    url="https://www.apkmirror.com/apk/google-inc/youtube-music/youtube-music-${1//./-}-release/"
    url="$url$(req "$url" - | grep arm64 -A30 | grep youtube-music | head -1 | sed "s#.*-release/##g;s#/\".*##g")"
    url="https://www.apkmirror.com$(req "$url" - | tr '\n' ' ' | sed -n 's;.*href="\(.*key=[^"]*\)">.*;\1;p')"
    url="https://www.apkmirror.com$(req "$url" - | tr '\n' ' ' | sed -n 's;.*href="\(.*key=[^"]*\)">.*;\1;p')"
    req "$url" "$2"
  }

   clear
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
         command="java -jar revanced-cli.jar -a YouTube_Music.apk -c -b revanced-patches.jar --custom-aapt2-binary=/data/data/com.termux/files/home/rvxtemp/aapt2 --keystore /data/data/com.termux/files/home/.keystore/revanced.keystore -m inte.apk --experimental -o youtube_music_patched.apk -i custom-branding-name -i custom-branding-music-afn-red -e custom-branding-music-revancify -e custom-branding-music-afn-blue"
       elif [ "$icon" == "2" ]; then
         # If the icon is "revancify", change custom-branding-any to "revancify"
         command="java -jar revanced-cli.jar --keystore /data/data/com.termux/files/home/.keystore/revanced.keystore -a YouTube_Music.apk -c -b revanced-patches.jar -m inte.apk --experimental -o youtube_music_patched.apk -i custom-branding-name -i custom-branding-music-afn-blue --custom-aapt2-binary=/data/data/com.termux/files/home/rvxtemp/aapt2 -e custom-branding-music-red -e custom-branding-music-revancify"
        elif [ "$icon" == "3" ]; then
         # If the icon is "revancify", change custom-branding-any to "revancify"
         command="java -jar revanced-cli.jar --keystore /data/data/com.termux/files/home/.keystore/revanced.keystore -a YouTube_Music.apk -c -b revanced-patches.jar -m inte.apk --experimental -o youtube_music_patched.apk -i custom-branding-name -i custom-branding-music-afn-blue --custom-aapt2-binary=/data/data/com.termux/files/home/rvxtemp/aapt2 -e custom-branding-music-red -i custom-branding-music-revancify"
        elif [ "$icon" == "4" ]; then
         # If the icon is "og", change custom-branding-any to "og"
         command="java -jar revanced-cli.jar -a YouTube_Music.apk -c -b revanced-patches.jar -m inte.apk --experimental --keystore /data/data/com.termux/files/home/.keystore/revanced.keystore -o youtube_music_patched.apk -i custom-branding-name -e custom-branding-music-revancify -e custom-branding-music-afn-blue -e custom-branding-music-afn-red --custom-aapt2-binary=/data/data/com.termux/files/home/rvxtemp/aapt2"
       else
           # If the icon is something else, print an error message and set the icon variable to an empty string
           echo "Invalid icon color. Please try again."
           icon=""
     fi

   # Execute the modified command
   $command
   mkdir /sdcard/"revanced extended apks" && mv  youtube_music_patched.apk /sdcard/"revanced extended apks" && termux-open /sdcard/"revanced extended apks"/youtube_music_patched.apk
    cd || exit
    rm -r -d rvxtemp

    clear
    echo "thanks for using my script! hope you have fun with revanced extended!"
    echo "if for whatever reason the package installer didnt pop up, u can go to your file manager app, u will see folder named "revanced extended apks" install the apk from there"
   fi
  done
 else
  echo "Invalid input. Exiting the script..."
  exit 1
  fi
exit 0
elif [ "$var" -eq 2 ]; then
   WGET_HEADER="User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101 Firefox/102.0"

   #download youtube
    req() {
      wget -O "$2" --header="$WGET_HEADER" "$1"
    }

  get_latestytversion() {
      YTVERSION=$(su -c dumpsys package com.google.android.youtube | grep versionName | cut -d '=' -f 2 | sed -n '1p')
      echo "Installed Youtube Version: $YTVERSION"
 }

   dl_yt() {
      rm -rf "$2"
      echo "Downloading YouTube $1"
      url="https://www.apkmirror.com/apk/google-inc/youtube/youtube-${1//./-}-release/"
      url="$url$(req "$url" - | grep Variant -A50 | grep ">APK<" -A2 | grep android-apk-download | sed "s#.*-release/##g;s#/\#.*##g")"
      url="https://www.apkmirror.com$(req "$url" - | tr '\n' ' ' | sed -n 's;.*href="\(.*key=[^"]*\)">.*;\1;p')"
      url="https://www.apkmirror.com$(req "$url" - | tr '\n' ' ' | sed -n 's;.*href="\(.*key=[^"]*\)">.*;\1;p')"
      req "$url" "$2"
  }
  elif [ "$ytver" -eq 2 ]; then

   WGET_HEADER="User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101 Firefox/102.0"

   #download youtube
    req() {
      wget -O "$2" --header="$WGET_HEADER" "$1"
    }

   get_latestytversion() {
      curl -L "$PATCH_JSON" -o patches.json 
     YTVERSION=$(jq -r '.[] | select(.compatiblePackages[].name == "com.google.android.youtube") | .compatiblePackages[].versions | .[]' patches.json | sort -n | tail -1)
      echo "Latest Youtube Version: $YTVERSION"
 }

   dl_yt() {
      rm -rf "$2"
      echo "Downloading YouTube $1"
      url="https://www.apkmirror.com/apk/google-inc/youtube/youtube-${1//./-}-release/"
      url="$url$(req "$url" - | grep Variant -A50 | grep ">APK<" -A2 | grep android-apk-download | sed "s#.*-release/##g;s#/\#.*##g")"
      url="https://www.apkmirror.com$(req "$url" - | tr '\n' ' ' | sed -n 's;.*href="\(.*key=[^"]*\)">.*;\1;p')"
      url="https://www.apkmirror.com$(req "$url" - | tr '\n' ' ' | sed -n 's;.*href="\(.*key=[^"]*\)">.*;\1;p')"
      req "$url" "$2"
  }
  fi
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
 PATCH_JSON=$(curl https://api.github.com/repos/$ORG/$REPO1/releases/latest | jq -r ".assets[] | select(.name | startswith(\"patches\") and endswith(\".json\")) | .browser_download_url")

 echo "downloading required files for patching (around 60mb), it will automatically removed after finished patching"
 # Download the files
 aria2c -x 8 -s 8 -k 1M -o inte.apk "$FILE_URL3"
 aria2c -x 8 -s 8 -k 1M -o revanced-cli.jar "$FILE_URL2"
 aria2c -x 8 -s 8 -k 1M -o revanced-patches.jar "$FILE_URL1"
 aria2c -x 8 -s 8 -k 1M -o aapt2 https://github.com/HoriKyoukosimp/goofyahh/releases/download/aapt2/aapt2
 aria2c -x 8 -s 8 -k 1M -o /data/data/com.termux/files/home/.keystore/revanced.keystore https://raw.githubusercontent.com/decipher3114/Revancify/main/revanced.keystore --allow-overwrite=false
  }
 if [ "$patch" -eq 1 ]; then
  # Prompt the user to enter the new values
  echo "Enter the new YouTube app name: "
  read app_name
  echo "root variants selected, unable to change application package name"
  sleep 1

  clear

  # Use sed to update the options.json file
  sed -i "s/YouTube_AppName.*/YouTube_AppName = \"$app_name\"/" options.toml
 
  # Prompt the user to select a theme option
  clear
  echo "Select a theme option:"
  echo "1 is default"
  echo "2 is monet/material you"
  echo "3 is amoled"
  echo "4 is amoled + monet/material you"

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
         command="$patchiconred -e theme -e materialyou"
       elif [ "$icon" == "2" ]; then
         # If the icon is "blue", change custom-branding-any to "blue"
         command="$patchiconblue -e theme -e materialyou"
       elif [ "$icon" == "3" ]; then
         # If the icon is "revancify", change custom-branding-any to "revancify"
         command="$patchiconrevancify -e theme -e materialyou"
        elif [ "$icon" == "4" ]; then
         # If the icon is "revancify", change custom-branding-any to "og"
         command="$patchiconog -e theme -e materialyou"
       else
           # If the icon is something else, print an error message and set the icon variable to an empty string
           echo "Invalid icon color. Please try again."
           icon=""
     fi

   # Execute the modified command
   $command
   mkdir /sdcard/"revanced extended apks" && mv  youtube_patched.apk /sdcard/"revanced extended apks"    
   su -mm -c 'grep com.google.android.youtube /proc/mounts  | cut -d " " -f 2 | sed "s/apk.*/apk/" | xargs -r umount -l > /dev/null 2>&1; done &&\
   cp /data/data/com.termux/files/home/storage/"revanced extended apks" "youtube_patched".apk /data/local/tmp/revanced.delete &&\
   mv /data/local/tmp/revanced.delete /data/adb/revanced/"com.google.android.youtube".apk &&\
   stockapp=$(pm path com.google.android.youtube | grep base | sed "s/package://g") &&\
   revancedapp=/data/adb/revanced/"com.google.android.youtube".apk &&\
   chmod 644 "$revancedapp" &&\
   chown system:system "$revancedapp" &&\
   chcon u:object_r:apk_data_file:s0 "$revancedapp" &&\
   mount -o bind "$revancedapp" "$stockapp" &&\
   am force-stop com.google.android.youtube' 2>&1 .mountlog
   clear
   echo "revanced extended should be mounted by now"
   echo "to uninstall (unmount), please run ./uninstall.sh into termux
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
         command="$patchiconred -e theme -i materialyou"
       elif [ "$icon" == "2" ]; then
         # If the icon is "blue", change custom-branding-any to "blue"
         command="$patchiconblue -e theme -i materialyou"
       elif [ "$icon" == "3" ]; then
         # If the icon is "revancify", change custom-branding-any to "revancify"
         command="$patchiconrevancify -e theme -i materialyou"
        elif [ "$icon" == "4" ]; then
         # If the icon is "revancify", change custom-branding-any to "og"
         command="$patchiconog -e theme -i materialyou"   
        else
         # If the icon is something else, print an error message and set the icon variable to an empty string
         echo "Invalid icon color. Please try again."
         icon=""
       fi
   # Execute the modified command
   $command
   mkdir /sdcard/"revanced extended apks" && mv  youtube_patched.apk /sdcard/"revanced extended apks"    
   su -mm -c 'grep com.google.android.youtube /proc/mounts  | cut -d " " -f 2 | sed "s/apk.*/apk/" | xargs -r umount -l > /dev/null 2>&1; done &&\
   cp /data/data/com.termux/files/home/storage/"revanced extended apks" "youtube_patched".apk /data/local/tmp/revanced.delete &&\
   mv /data/local/tmp/revanced.delete /data/adb/revanced/"com.google.android.youtube".apk &&\
   stockapp=$(pm path com.google.android.youtube | grep base | sed "s/package://g") &&\
   revancedapp=/data/adb/revanced/"com.google.android.youtube".apk &&\
   chmod 644 "$revancedapp" &&\
   chown system:system "$revancedapp" &&\
   chcon u:object_r:apk_data_file:s0 "$revancedapp" &&\
   mount -o bind "$revancedapp" "$stockapp" &&\
   am force-stop com.google.android.youtube' 2>&1 .mountlog
   clear
   echo "revanced extended should be mounted by now"
   echo "to uninstall (unmount), please run ./uninstall.sh into termux"
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
         command="$patchiconred -i theme -e materialyou"
       elif [ "$icon" == "2" ]; then
         # If the icon is "blue", change custom-branding-any to "blue"
         command="$patchiconblue -i theme -e materialyou"
       elif [ "$icon" == "3" ]; then
         # If the icon is "revancify", change custom-branding-any to "revancify"
         command="$patchiconrevancify -i theme -e materialyou"
        elif [ "$icon" == "4" ]; then
         # If the icon is "revancify", change custom-branding-any to "og"
         command="$patchiconog -i theme -e materialyou"
        else
         # If the icon is something else, print an error message and set the icon variable to an empty string
         echo "Invalid icon color. Please try again."
         icon=""
     fi
    # Execute the modified command
    $command
    mkdir /sdcard/"revanced extended apks" && mv  youtube_patched.apk /sdcard/"revanced extended apks"    
     su -mm -c 'grep com.google.android.youtube /proc/mounts  | cut -d " " -f 2 | sed "s/apk.*/apk/" | xargs -r umount -l > /dev/null 2>&1; done &&\
    cp /data/data/com.termux/files/home/storage/"revanced extended apks" "youtube_patched".apk /data/local/tmp/revanced.delete &&\
     mv /data/local/tmp/revanced.delete /data/adb/revanced/"com.google.android.youtube".apk &&\
     stockapp=$(pm path com.google.android.youtube | grep base | sed "s/package://g") &&\
     revancedapp=/data/adb/revanced/"com.google.android.youtube".apk &&\
     chmod 644 "$revancedapp" &&\
     chown system:system "$revancedapp" &&\
     chcon u:object_r:apk_data_file:s0 "$revancedapp" &&\
     mount -o bind "$revancedapp" "$stockapp" &&\
     am force-stop com.google.android.youtube' 2>&1 .mountlog
     clear
     echo "revanced extended should be mounted by now"
     echo "to uninstall (unmount), please run ./uninstall.sh into termux
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
         command="$patchiconred -i theme -i materialyou"
       elif [ "$icon" == "2" ]; then
         # If the icon is "blue", change custom-branding-any to "blue"
         command="$patchiconblue -i theme -i materialyou"
       elif [ "$icon" == "3" ]; then
         # If the icon is "revancify", change custom-branding-any to "revancify"
         command="$patchiconrevancify -i theme -i materialyou"
        elif [ "$icon" == "4" ]; then
         # If the icon is "revancify", change custom-branding-any to "og"
         command="$patchiconog -i theme -i materialyou"
       else
         # If the icon is something else, print an error message and set the icon variable to an empty string
         echo "Invalid icon color. Please try again."
         icon=""
     fi
    # Execute the modified command
    $command
       mkdir /sdcard/"revanced extended apks" && mv  youtube_patched.apk /sdcard/"revanced extended apks"    
       su -mm -c 'grep com.google.android.youtube /proc/mounts  | cut -d " " -f 2 | sed "s/apk.*/apk/" | xargs -r umount -l > /dev/null 2>&1; done &&\
       cp /data/data/com.termux/files/home/storage/"revanced extended apks" "youtube_patched".apk /data/local/tmp/revanced.delete &&\
       mv /data/local/tmp/revanced.delete /data/adb/revanced/"com.google.android.youtube".apk &&\
       stockapp=$(pm path com.google.android.youtube | grep base | sed "s/package://g") &&\
       revancedapp=/data/adb/revanced/"com.google.android.youtube".apk &&\
       chmod 644 "$revancedapp" &&\
       chown system:system "$revancedapp" &&\
       chcon u:object_r:apk_data_file:s0 "$revancedapp" &&\
       mount -o bind "$revancedapp" "$stockapp" &&\
       am force-stop com.google.android.youtube' 2>&1 .mountlog
       clear
       echo "revanced extended should be mounted by now"
       echo "to uninstall (unmount), please run ./uninstall.sh into termux
     else
     # If the user enters an invalid option, print an error message and exit the script
     echo "Invalid option. Exiting script."
     exit 1
   fi
   done 
  fi
 elif [ "$patch" -eq 2 ]; then
  echo "PLEASE FOR GOD SAKE, INSTALL YOUTUBE MUSIC FIRST, I'M TOO LAZY TO MAKE THIS SCRIPT DETECT IF THE APP WAS INSTALLED OR NAH"
  sleep 2
  echo "unable to change youtube music app name (limitation for now)"
  echo "you have selected root variants, unable to change application package name"
  sleep 2

  # Use sed to update the options.json file
  sed -i "s/Music_PackageName.*/Music_PackageName = \"$package_name\"/" options.toml
  #download youtube music
   WGET_HEADER="User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101 Firefox/102.0"

   #download youtube
    req() {
      wget -O "$2" --header="$WGET_HEADER" "$1"
    }
  get_latestytmversion() {
      YTMVERSION=$(su -c dumpsys package com.google.android.apps.youtube.music | grep versionName | cut -d '=' -f 2 | sed -n '1p')
      echo "Installed Youtube Music Version: $YTMVERSION"
  }


  dl_ytm() {
    rm -rf "$2"
    echo "Downloading YouTube Music $1"
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
         command="java -jar revanced-cli.jar -a YouTube_Music.apk -c -b revanced-patches.jar --custom-aapt2-binary=/data/data/com.termux/files/home/rvxtemp/aapt2 --keystore /data/data/com.termux/files/home/.keystore/revanced.keystore -m inte.apk --experimental -o youtube_music_patched.apk -i custom-branding-name -i custom-branding-music-afn-red -e custom-branding-music-revancify -e custom-branding-music-afn-blue"
       elif [ "$icon" == "2" ]; then
         # If the icon is "revancify", change custom-branding-any to "revancify"
         command="java -jar revanced-cli.jar --keystore /data/data/com.termux/files/home/.keystore/revanced.keystore -a YouTube_Music.apk -c -b revanced-patches.jar -m inte.apk --experimental -o youtube_music_patched.apk -i custom-branding-name -i custom-branding-music-afn-blue --custom-aapt2-binary=/data/data/com.termux/files/home/rvxtemp/aapt2 -e custom-branding-music-red -e custom-branding-music-revancify"
        elif [ "$icon" == "3" ]; then
         # If the icon is "revancify", change custom-branding-any to "revancify"
         command="java -jar revanced-cli.jar --keystore /data/data/com.termux/files/home/.keystore/revanced.keystore -a YouTube_Music.apk -c -b revanced-patches.jar -m inte.apk --experimental -o youtube_music_patched.apk -i custom-branding-name -i custom-branding-music-afn-blue --custom-aapt2-binary=/data/data/com.termux/files/home/rvxtemp/aapt2 -e custom-branding-music-red -i custom-branding-music-revancify"
        elif [ "$icon" == "4" ]; then
         # If the icon is "og", change custom-branding-any to "og"
         command="java -jar revanced-cli.jar -a YouTube_Music.apk -c -b revanced-patches.jar -m inte.apk --experimental --keystore /data/data/com.termux/files/home/.keystore/revanced.keystore -o youtube_music_patched.apk -i custom-branding-name -e custom-branding-music-revancify -e custom-branding-music-afn-blue -e custom-branding-music-afn-red --custom-aapt2-binary=/data/data/com.termux/files/home/rvxtemp/aapt2"
       else
           # If the icon is something else, print an error message and set the icon variable to an empty string
           echo "Invalid icon color. Please try again."
           icon=""
     fi

   # Execute the modified command
   $command
   mkdir /sdcard/"revanced extended apks" && mv  youtube_music_patched.apk /sdcard/"revanced extended apks"    
   su -mm -c 'grep com.google.android.apps.youtube.music /proc/mounts  | cut -d " " -f 2 | sed "s/apk.*/apk/" | xargs -r umount -l > /dev/null 2>&1; done &&\
   cp /data/data/com.termux/files/home/storage/"revanced extended apks" "youtube_music_patched".apk /data/local/tmp/revanced.delete &&\
   mv /data/local/tmp/revanced.delete /data/adb/revanced/"com.google.android.apps.youtube.music".apk &&\
   stockapp=$(pm path com.google.android.apps.youtube.music | grep base | sed "s/package://g") &&\
   revancedapp=/data/adb/revanced/"com.google.android.apps.youtube.music".apk &&\
   chmod 644 "$revancedapp" &&\
   chown system:system "$revancedapp" &&\
   chcon u:object_r:apk_data_file:s0 "$revancedapp" &&\
   mount -o bind "$revancedapp" "$stockapp" &&\
   am force-stop com.google.android.apps.youtube.music' 2>&1 .mountlog
   clear
   echo "revanced extended should be mounted by now"
   echo "to uninstall (unmount), please run ./uninstall.sh into termux"
   fi
  done
exit 0
fi
