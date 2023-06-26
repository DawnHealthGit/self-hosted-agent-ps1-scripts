sudo snap install docker

sudo groupadd docker
sudo usermod -aG docker $USER
sudo newgrp docker

sudo reboot