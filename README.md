Clone the git using:

git clone https://github.com/muralibonagani/Merging-Google-Assistant-and-Amazon-Alexa  
to make the insaller ready to compile:

sudo chmod +x /home/pi/Assistants-Pi/prep-system.sh    
sudo chmod +x /home/pi/Assistants-Pi/audio-test.sh   
sudo chmod +x /home/pi/Assistants-Pi/installer.sh  

Prepare the system to make ready to install Voice Assistants
sudo /home/pi/Assistants-Pi/prep-system.sh

Restart Pi using:
sudo reboot

For the the sound output:
Make sure that contents of asoundrc match the contents of asound.conf

Open a terminal and type:
sudo nano /etc/asound.conf

Open a second terminal and type:
sudo nano ~/.asoundrc

If the contents of .asoundrc are not same as asound.conf, copy the contents from asound.conf to .asoundrc, save using ctrl+x and y
Test the audio setup using:
sudo /home/pi/Assistants-Pi/audio-test.sh  

Restart Pi using:
sudo reboot

For the working of USB Mic in the Pi
Create/edit file .asoundrc
$vim .asoundrc
If file is not present create it;
$ touch .asoundrc
$vim .asoundrc 
pcm.!default {
        type asym
        playback.pcm "hw:1,0"
        capture.pcm "hw:1,0"
}
ctl.!default {
        type hw
        card 1
}
Edit below line in file alsa.conf;
$sudo vim /usr/share/alsa/alsa.conf
defaults.ctl.card 0
defaults.pcm.card 0
to

$sudo vim /usr/share/alsa/alsa.conf
defaults.ctl.card 1
defaults.pcm.card 1
Change audio levels/setting using alsamixer utility

$alsamixer
Command to record audio

$arecord -D plughw:1 -f S16_LE -r 48000 -d 5 ./testSound.wav
Command to play recorded audio

$aplay --device=plughw:1,0 ./testSound.wav

Install the assistant/assistants using the following:
sudo /home/pi/Assistants-Pi/installer.sh  

After verification of the assistants, to make them auto start on boot:
Pi 3 and Pi2 users, open the gassistpi-ok-google.service in the /home/pi/Assistants-Pi/systemd folder and add your project-id and model-id with the project id smart speaker and the model id is Pi3
After that, open a terminal and run the following commands:

sudo chmod +x /home/pi/Assistants-Pi/scripts/service-installer.sh
sudo chmod +x /home/pi/Assistants-Pi/scripts/clientstart.sh  
sudo chmod +x /home/pi/Assistants-Pi/scripts/companionstart.sh  
sudo chmod +x /home/pi/Assistants-Pi/scripts/wakeword.sh  
sudo /home/pi/Assistants-Pi/scripts/service-installer.sh  
sudo systemctl enable companionapp.service
sudo systemctl enable client.service
sudo systemctl enable wakeword.service
sudo systemctl enable stopbutton.service

use the following command to enable google assistant in Pi 3B

sudo systemctl enable gassistpi-ok-google.service  

Manually Start The Google Assistant
At any point of time, if you wish to manually start the assistant:

Ok-Google Hotword/Pi3/Pi2/Armv7 users
Open a terminal and execute the following:

/home/pi/env/bin/python -u /home/pi/GassistPi/src/main.py --device_model_id 'replace this with the model id'

Pushbutton/Pi Zero/Pi B+ and other users
Open a terminal and execute the following:

/home/pi/env/bin/python -u /home/pi/GassistPi/src/pushbutton.py --project-id 'replace this with your project id'  --device-model-id 'replace this with the model id'
