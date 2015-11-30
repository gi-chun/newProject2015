#import <CoreFoundation/CoreFoundation.h>

NSString* getModel(void);
NSString* getOSVersion(void);
NSString* getTelecomCarrierName(void);
NSString* getISOCountryCode(void);
NSString* getMobileNetworkCode(void);
NSString* getNetworkStatus(void);
NSString* getWiFiMACAddress(void);
NSString* getEthernetMACAddress(void);
NSString* getExternalIPAddress(NSString* serverIPstr, unsigned short serverPortNbr, Boolean isDisconnected);
NSString* getInternalIPAddress1(void);
NSString* getInternalIPAddress2(void);
NSString* getSSID(void);
NSString* getBSSID(void);
NSString* getCellNumber(void);
NSString* getUserAccount(void);
NSString* checkRoot(void);
NSString* checkProxy(void);
NSString* getProxyInfo(void);
NSString* getUUID1(NSString *accessGroupStr);
NSString* getUUID2(NSString *accessGroupStr);
NSString* getResultSum(NSString* serverIPstr, unsigned short serverPortNbr, Boolean isDisconnected, NSString *accessGroupStr);