//
//  AppDelegate.m
//  Iwordsv2
//
//  Created by yaonphy on 12-10-26.
//  Copyright (c) 2012年 yang. All rights reserved.
//

#import "AppDelegate.h"
#import "RootNavViewController.h"
#import "GuidViewController.h"
#import "FMDatabase.h"
@implementation AppDelegate
- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    NSString * firstPath = [[NSBundle mainBundle] pathForResource:@"IsFirstInto" ofType:@"plist"];
    NSMutableDictionary * firstDic = [[NSMutableDictionary alloc]initWithContentsOfFile:firstPath];
    BOOL firstIntoApp = (BOOL)[firstDic valueForKey:@"firstInto"];
    
    if (firstIntoApp) {
        [GuidViewController show];
        firstPath  = NO;
        [firstDic setValue:firstPath forKey:@"firstInto"];
        [firstDic writeToFile:firstPath atomically:YES];
    }else
    {
        RootNavViewController *rootController = [[RootNavViewController alloc]init];
        [[self window]setRootViewController:rootController];
        [rootController release];
         rootController = nil;
    }

    [firstDic release];
    
    @autoreleasepool {
        NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) objectAtIndex:0];
        
        NSString * dbPath = [docPath stringByAppendingPathComponent:@"review.sqlite"];
        NSLog(@"%@\n",dbPath);
        NSFileManager * fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:dbPath]) {
            FMDatabase * reviewDB = [FMDatabase databaseWithPath:dbPath];
            NSAssert(reviewDB, @"创建复习数据库失败！！");
            
            if ([reviewDB open]) {
                NSString * sql = @"CREATE TABLE 'ReviewTable' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL , 'word' VARCHAR(30))";
                BOOL res = [reviewDB executeUpdate:sql];
                if (!res) {
                    NSLog(@"error when creating db table:ReviewTable ");
                } else {
                    NSLog(@"succ to creating db table:ReviewTable");
                }
                
                NSString * sql22 = @"CREATE TABLE 'VocabTable' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL , 'word' VARCHAR(30))";
                res = [reviewDB executeUpdate:sql22];
                if (!res) {
                    NSLog(@"error when creating db table VocabTable ");
                } else {
                    NSLog(@"succ to creating db table VocabTable ");
                }
                
                [reviewDB close];
            } else {
                NSLog(@"error when open db");
            }
        }

    
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
