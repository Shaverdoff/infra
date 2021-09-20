
# билд проекта
sudo chmod +x gradlew
./gradlew build

# Очистка проекта	
gradle clean

# версия
gradle -v

# скачивает портабл версию грэдла и билдит	
gradlew build

# билд отдельного куска
gradle discovery-server:build

для копирования war into /bin
./gradlew muleapp
