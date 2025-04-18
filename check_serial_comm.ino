#include <ArduinoBLE.h>

BLEService customService("19b10000-e8f2-537e-4f6c-d104768a1214");
BLECharacteristic rxChar("19b10001-e8f2-537e-4f6c-d104768a1214", BLEWrite, 20);
BLECharacteristic txChar("19b10002-e8f2-537e-4f6c-d104768a1214", BLENotify, 20);

void setup() {
  Serial.begin(9600);
  if (!BLE.begin()) {
    Serial.println("BLE init failed");
    while (1);
  }

  BLE.setLocalName("GIGA_R1_BLE");
  BLE.setAdvertisedService(customService);

  customService.addCharacteristic(rxChar);
  customService.addCharacteristic(txChar);

  BLE.addService(customService);

  BLE.advertise();
  Serial.println("BLE device active, waiting for connections...");
}

void loop() {
  BLEDevice central = BLE.central();
  if (central) {
    Serial.println("Connected to central");
    while (central.connected()) {
      if (rxChar.written()) {
        int len = rxChar.valueLength();
        const uint8_t* rawData = rxChar.value();

        String input = "";
        for (int i = 0; i < len; i++) {
          input += (char)rawData[i];
        }

        Serial.print("Received: ");
        Serial.println(input);

        String ack = "Ack:" + input;
        txChar.writeValue(ack.c_str());
      }
    }
    Serial.println("Disconnected");
  }
}
