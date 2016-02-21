//
//  HKSnippetSetting.m
//  HKSnippet
//
//  Created by Hunk on 16/2/4.
//  Copyright © 2016年 Taobao.com. All rights reserved.
//

#import "HKSnippetSetting.h"

NSString * const kHKSnippetsKey = @"snippets";
NSString * const kHKSnippetEnabled = @"enabled";

@implementation HKSnippetSetting

- (instancetype)init {
    self = [super init];
    if (self) {
        _systemTriggers = @[@"@autoreleasepool",
                            @"@catch",
                            @"@class",
                            @"@compatibility_alias",
                            @"@defs",
                            @"@dynamic",
                            @"@encode",
                            @"@end",
                            @"@finally",
                            @"@import",
                            @"@interface",
                            @"@implementation",
                            @"@optional",
                            @"@package",
                            @"@private",
                            @"@property",
                            @"@protected",
                            @"@protocol",
                            @"@public",
                            @"@required",
                            @"@selector",
                            @"@synchronized",
                            @"@synthesize",
                            @"@throw"
                            ];
        _snippets = [NSMutableDictionary dictionaryWithDictionary:[self defaultConfig]];
    }
    return self;
}

+ (HKSnippetSetting *)defaultSetting {
    static HKSnippetSetting *defaultSetting;
    static dispatch_once_t once;
    dispatch_once(&once, ^ {
        defaultSetting = [[HKSnippetSetting alloc] init];
        
        NSDictionary *defaults = @{kHKSnippetEnabled: @YES,
                                   kHKSnippetsKey : defaultSetting.snippets ? defaultSetting.snippets : @{}};
        [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
    });
    return defaultSetting;
}

- (BOOL)enabled {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kHKSnippetEnabled];
}

- (void)setEnabled:(BOOL)enabled {
    [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:kHKSnippetEnabled];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)sychronizeSetting {
    NSMutableDictionary *snippets = [HKSnippetSetting defaultSetting].snippets;
    [[NSUserDefaults standardUserDefaults] setObject:snippets forKey:kHKSnippetsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)resetToDefaultSetting {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kHKSnippetsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    _snippets = nil;
    _snippets = [NSMutableDictionary dictionaryWithDictionary:[self defaultConfig]];
    [[NSUserDefaults standardUserDefaults] setObject:[self defaultConfig] forKey:kHKSnippetsKey];
    [self setEnabled:YES];
}

- (NSDictionary *)defaultConfig {
    NSDictionary *config = [[NSUserDefaults standardUserDefaults] objectForKey:kHKSnippetsKey];
    if (config.count > 0) {
        return config;
    }
    NSString *default_snippet_file = [[NSBundle mainBundle] pathForResource:@"default_snippets"
                                                                     ofType:@"plist"];
    config = [NSDictionary dictionaryWithContentsOfFile:default_snippet_file];
    return config;
}

@end