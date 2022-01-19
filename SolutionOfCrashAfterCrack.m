#import <Foundation/Foundation.h>

#import "CaptainHook/CaptainHook.h"

// This library is not useful for active detection cracking's applications.
// 这个库不对主动检测砸壳的应用起作用

// Most applications only need to hook AppGroup and CloudKit.
// 大多数应用只需要hook AppGroup和CloudKit的部分

/* AppGroup */
CHDeclareClass(NSFileManager);
CHOptimizedMethod(1, self, NSURL *, NSFileManager, containerURLForSecurityApplicationGroupIdentifier, NSString *, groupIdentifier) {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    [self createDirectoryAtPath:[documentsPath stringByAppendingPathComponent:@"OriginalAppGroup"] withIntermediateDirectories:YES attributes:nil error:nil];
    return [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/OriginalAppGroup", documentsPath]];
}

/* CloudKit */
CHDeclareClass(CKContainer);
CHOptimizedMethod(1, self, id, CKContainer, _initWithContainerIdentifier, id, arg1) {
    return nil;
}

/* SiriKit */
CHDeclareClass(INPreferences);
CHOptimizedMethod(0, self, void, INPreferences, assertThisProcessHasSiriEntitlement) {
    return;
}

CHConstructor {
    @autoreleasepool {
        CHLoadLateClass(NSFileManager);
        CHHook(1, NSFileManager, containerURLForSecurityApplicationGroupIdentifier);

        CHLoadLateClass(CKContainer);
        CHHook(1, CKContainer, _initWithContainerIdentifier);

        CHLoadLateClass(INPreferences);
        CHHook(0, INPreferences, assertThisProcessHasSiriEntitlement);
    }
}
