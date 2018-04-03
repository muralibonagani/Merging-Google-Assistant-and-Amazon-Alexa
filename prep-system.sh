#!/bin/bash

select_option()
{
  local _result=$1
  local ARGS=("$@")
  if [ "$#" -gt 0 ]; then
      while [ true ]; do
         local count=1
         for option in "${ARGS[@]:1}"; do
            echo "$count) $option"
            ((count+=1))
         done
         echo ""
         local USER_RESPONSE
         read -p "Please select an option [1-$(($#-1))] " USER_RESPONSE
         case $USER_RESPONSE in
             ''|*[!0-9]*) echo "Please provide a valid number"
                          continue
                          ;;
             *) if [[ "$USER_RESPONSE" -gt 0 && $((USER_RESPONSE+1)) -le "$#" ]]; then
                    local SELECTION=${ARGS[($USER_RESPONSE)]}
                    echo "Selection: $SELECTION"
                    eval $_result=\$SELECTION
                    return
                else
                    clear
                    echo "Please select a valid option"
                fi
                ;;
         esac
      done
  fi
}

echo ""
echo "========== Updating and Upgrading System==========="
sudo apt-get update
sudo apt-get install raspberrypi-kernel -yq
sudo apt-get upgrade -yq
echo ""
echo ""
echo "Select your audio and mic configuration: "
select_option audio AIY-HAT CUSTOM-VOICE-HAT USB-MIC-ON-BOARD-JACK USB-MIC-HDMI USB-SOUND-CARD-or-DAC
echo ""
echo "You have chosen to use $audio audio configuration"
echo ""
case $audio in
    AIY-HAT)
        sudo chmod +x /home/pi/Assistants-Pi/audio-drivers/AIY-HAT/scripts/configure-driver.sh  
        sudo /home/pi/Assistants-Pi/audio-drivers/AIY-HAT/scripts/configure-driver.sh
        sudo chmod +x /home/pi/Assistants-Pi/audio-drivers/AIY-HAT/scripts/install-alsa-config.sh
        sudo /home/pi/Assistants-Pi/audio-drivers/AIY-HAT/scripts/install-alsa-config.sh
        ;;
    CUSTOM-VOICE-HAT)
        sudo chmod +x /home/pi/Assistants-Pi/audio-drivers/CUSTOM-VOICE-HAT/scripts/custom-voice-hat.sh
        sudo /home/pi/Assistants-Pi/audio-drivers/CUSTOM-VOICE-HAT/scripts/custom-voice-hat.sh
        sudo chmod +x /home/pi/Assistants-Pi/audio-drivers/CUSTOM-VOICE-HAT/scripts/install-i2s.sh
        sudo /home/pi/Assistants-Pi/audio-drivers/CUSTOM-VOICE-HAT/scripts/install-i2s.sh
        ;;
    USB-MIC-ON-BOARD-JACK)
        sudo chmod +x /home/pi/Assistants-Pi/audio-drivers/USB-MIC-JACK/scripts/usb-mic-onboard-jack.sh
        sudo /home/pi/Assistants-Pi/audio-drivers/USB-MIC-JACK/scripts/usb-mic-onboard-jack.sh
        sudo amixer cset numid=3 1
        echo "Audio set to be forced through 3.5mm jack."
        ;;
    USB-MIC-HDMI)
        sudo chmod +x /home/pi/Assistants-Pi/audio-drivers/USB-MIC-HDMI/scripts/install-usb-mic-hdmi.sh
        sudo /home/pi/Assistants-Pi/audio-drivers/USB-MIC-HDMI/scripts/install-usb-mic-hdmi.sh
        sudo amixer cset numid=3 2
        echo "Audio set to be forced through HDMI."
        ;;
    USB-SOUND-CARD-or-DAC)
        sudo chmod +x /home/pi/Assistants-Pi/audio-drivers/USB-DAC/scripts/install-usb-dac.sh
        sudo /home/pi/Assistants-Pi/audio-drivers/USB-DAC/scripts/install-usb-dac.sh
	  ;;
esac
echo ""
echo "Audio configuration for $audio done."
echo ""
echo "========== Installing Git ============"
sudo apt-get install -y git
echo ""
echo ""
echo "System has been updated and audio configuration files installed."
echo ""
echo "Restart the Pi and run the audio-test.sh script to make sure that your Microphone and Speaker are working."
echo ""
