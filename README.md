# Protocole_de_communication_i2c_spi

# ce repo  est pour bien comprendre les communications i2c et spi.

Dans les dossiers SPI et I2C, vous trouverez :

 - les schèmas proteus
 - les codes microC.

-- Dans ce repository, j'ai réaliser la commuinication entre le pic16F877A et le module MCP23X17 sans utilser les fonctions prédéfinis de MicroC pro for pic. 
Toute la communication est implémentée manuellement afin de manipuler directement les bits nécessaires au fonctionnement des protocoles I²C et SPI.
Le MCP23X17 (famille comprenant le MCP23017 pour i2c et le MCP23S17 pour spi) est un circuit intégré extenseur d'entrées/sorties (GPIO) 16 bits très utilisé avec les microcontrôleurs comme Arduino, pic, ESP32 ou Raspberry Pi. Il permet d'ajouter 16 broches numériques supplémentaires via une liaison I2C (MCP23017) ou SPI (MCP23S17), en n'utilisant que très peu de pins du contrôleur principal.

Dans ce projet :

les ports A et B du MCP23X17 sont configurés en sortie pour envoyer des données vers des LEDs connectées aux ports A et B

les ports du MCP23X17 sont ensuite lus, et les données sont affichées sur les ports du PIC16F877A

Ce projet simple permet de comprendre le fonctionnement bas niveau des protocoles I²C et SPI.
