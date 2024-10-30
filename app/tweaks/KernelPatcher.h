#import <Foundation/Foundation.h>

@interface KernelPatcher : NSObject

+ (instancetype)sharedPatcher;
- (BOOL)patchKernelWithPayload:(NSData *)payload;
- (BOOL)revertKernelPatches;
- (NSDictionary *)getKernelInfo;

@end