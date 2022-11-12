#import <UIKit/UIKit.h>

%hook PKPaymentDevice
+(id)clientInfoHTTPHeader{
	NSString *os_version = [[UIDevice currentDevice] systemVersion];
	NSString *org = %orig;
	// figure a way to find the OS Build number to replace it
	org = [org stringByReplacingOccurrencesOfString:os_version withString:@"15.3"];
	return org;
}

%end