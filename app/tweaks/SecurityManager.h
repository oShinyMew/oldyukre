#import <Foundation/Foundation.h>

@interface SecurityManager : NSObject

+ (instancetype)sharedManager;
- (void)enableSecurityFeature:(NSString *)feature;
- (void)disableSecurityFeature:(NSString *)feature;
- (BOOL)isFeatureEnabled:(NSString *)feature;
- (NSDictionary *)getSecurityStatus;

@end