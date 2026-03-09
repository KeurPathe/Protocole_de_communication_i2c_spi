# Protocole_de_communication_i2c_spi

# ce repo  est pour bien comprendre les communications i2c et spi.

Vous trouverez dans les dossiers SPI et i2c, les schèmas proteus et les codes microC.

-- Dans ce repository, j'ai réaliser la commuinication entre le pic16F877A et le module MCP23X17 sans utilser les fonctions prédéfinis de MicroC pro for pic. Tout est écrit et nous gère nous-même les bits nécessaires pour une bonne communication.

Le MCP23X17 (famille comprenant le MCP23017 pour i2c et le MCP23S17 pour spi) est un circuit intégré extenseur d'entrées/sorties (GPIO) 16 bits très utilisé avec les microcontrôleurs comme Arduino, pic, ESP32 ou Raspberry Pi. Il permet d'ajouter 16 broches numériques supplémentaires via une liaison I2C (MCP23017) ou SPI (MCP23S17), en n'utilisant que très peu de pins du contrôleur principal.

J'ai configurés les ports A et B du MCP en et les envoyer des données que j'ai affiché sur des led branchés aux ports A et B. Ensuite lire les ports du MCP et les afficher sur les PORTS du pic16F.

C'est un projet très simple pour bien comprender comment marchent l'i2c et le spi.
