#import <UIKit/UIKit.h>
#import <Cephei/HBPreferences.h>
#import <sys/sysctl.h>

static NSString *real_build; // A1313B
static NSString *real_version; // 14.1

static NSString *spoofed_build;
static NSString *spoofed_version;

static HBPreferences *tweakPrefs;
static BOOL isEnabled;

%hook HBForceCepheiPrefs
+ (BOOL)forceCepheiPrefsWhichIReallyNeedToAccessAndIKnowWhatImDoingISwear {
    return YES;
}
%end


// https://github.com/getsentry/sentry-cocoa/blob/5dc32b3c24ffad783cb76b1bd1200b30ffbd332a/Sources/Sentry/SentryDevice.mm#L246-L256
NSString *getOSBuildNumber(void){
    char str[32];
    size_t size = sizeof(str);
    int cmd[2] = { CTL_KERN, KERN_OSVERSION };
    if (sysctl(cmd, sizeof(cmd) / sizeof(*cmd), str, &size, NULL, 0) == 0) {
        return [NSString stringWithUTF8String:str];
    }
    return @"";
}


%hook PKPaymentDevice
+(id)clientInfoHTTPHeader{
	NSString *org = %orig;
	
	if (isEnabled) {
		static dispatch_once_t onceToken;
		dispatch_once(&onceToken, ^{
			real_version = [[UIDevice currentDevice] systemVersion];
			real_build = getOSBuildNumber();
			[tweakPrefs registerObject:&spoofed_build default:@"19D50" forKey:@"build"];
			[tweakPrefs registerObject:&spoofed_version default:@"15.3" forKey:@"version"];
			if ([spoofed_build isEqualToString:@""]){
				spoofed_build = @"19D50";
			}
			if ([spoofed_version isEqualToString:@""]){
				spoofed_version = @"15.3";
			}
		});

		org = [org stringByReplacingOccurrencesOfString:real_version withString:spoofed_version]; 
		org = [org stringByReplacingOccurrencesOfString:real_build withString:spoofed_build];
		}

	return org;
}

%end



%ctor {
	tweakPrefs = [[HBPreferences alloc] initWithIdentifier:@"dev.extbh.fixpay14"];
	[tweakPrefs registerBool:&isEnabled default:YES forKey:@"isEnabled"];
}