#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TweakManager : NSObject

+ (instancetype)sharedManager;

- (BOOL)applySystemTweak:(NSString *)tweakId;
- (BOOL)applySecurityTweak:(NSString *)tweakId;
- (BOOL)revertTweak:(NSString *)tweakId;
- (NSDictionary *)getTweakStatus:(NSString *)tweakId;
- (void)scanForVulnerabilities:(void(^)(NSDictionary *results))completion;

@end