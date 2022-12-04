#import <UIKit/UIKit.h>
#import <Cephei/HBPreferences.h>
#import <sys/sysctl.h>
#import <substrate.h>

static NSString *real_build; // A1313B
static NSString *real_version; // 14.1

static NSString *spoofed_build;
static NSString *spoofed_version;

static HBPreferences *tweakPrefs;
static BOOL isEnabled;

// nedded when hooking an app
/*
@class HBForceCepheiPrefs;
static BOOL override_HBForeCepheiPrefs_forceCepheiPrefsWhichIReallyNeedToAccessAndIKnowWhatImDoingISwear(HBForceCepheiPrefs *self, SEL _cmd){
    return YES;
}
*/

// https://github.com/getsentry/sentry-cocoa/blob/5dc32b3c24ffad783cb76b1bd1200b30ffbd332a/Sources/Sentry/SentryDevice.mm#L246-L256
static NSString *getOSBuildNumber(void){
    char str[32];
    size_t size = sizeof(str);
    int cmd[2] = { CTL_KERN, KERN_OSVERSION };
    if (sysctl(cmd, sizeof(cmd) / sizeof(*cmd), str, &size, NULL, 0) == 0) {
        return [NSString stringWithUTF8String:str];
    }
    return @"";
}

@class PKPaymentDevice;
static NSString *(*orig_PKPaymentDevice_clientInfoHTTPHeader)(PKPaymentDevice*, SEL);

static NSString *override_PKPaymentDevice_clientInfoHTTPHeader(PKPaymentDevice *self, SEL _cmd){
    NSString *header = orig_PKPaymentDevice_clientInfoHTTPHeader(self, _cmd);
    static dispatch_once_t prefsOnceToken;
    dispatch_once(
        &prefsOnceToken,
        ^{
            tweakPrefs = [[HBPreferences alloc] initWithIdentifier:@"dev.extbh.fixpay14"];
            [tweakPrefs registerBool:&isEnabled default:YES forKey:@"isEnabled"];
        }
        );
    if(isEnabled){
        static dispatch_once_t onceToken;
		dispatch_once(
            &onceToken, 
            ^{
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
        header = [header stringByReplacingOccurrencesOfString:real_version withString:spoofed_version];
        header = [header stringByReplacingOccurrencesOfString:real_build withString:spoofed_build];
        }
    return header;
}

__attribute__((constructor)) static void init(){
    /*
    MSHookMessageEx(
        NSClassFromString(@"HBForceCepheiPrefs"), 
        @selector(forceCepheiPrefsWhichIReallyNeedToAccessAndIKnowWhatImDoingISwear), 
        (IMP) &override_HBForeCepheiPrefs_forceCepheiPrefsWhichIReallyNeedToAccessAndIKnowWhatImDoingISwear, 
        NULL);
    */

    MSHookMessageEx(
        objc_getMetaClass("PKPaymentDevice"),
        @selector(clientInfoHTTPHeader),
        (IMP) &override_PKPaymentDevice_clientInfoHTTPHeader,
        (IMP *) &orig_PKPaymentDevice_clientInfoHTTPHeader
    );
}