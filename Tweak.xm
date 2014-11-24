#import <libactivator/libactivator.h>
#import <MediaPlayer/MediaPlayer.h>
#import <objc/runtime.h>
@interface SBApplicationController : NSObject {
}
+(id)sharedInstance;
+(id)applicationWithBundleIdentifier:(NSString *)identifier;
@end
@interface SBApplication : NSObject {
}
@property (nonatomic,readonly) int pid;
@end
MPMediaItemCollection *mediaItemCollection1;
MPMediaItemCollection *mediaItemCollection2;
MPMediaItemCollection *mediaItemCollection3;
MPMediaItemCollection *mediaItemCollection4;
MPMediaItemCollection *mediaItemCollection5;
static NSString *id1 = @"com.milodarling.quickphil.song1";
static NSString *id2 = @"com.milodarling.quickphil.song2";
static NSString *id3 = @"com.milodarling.quickphil.song3";
static NSString *id4 = @"com.milodarling.quickphil.song4";
static NSString *id5 = @"com.milodarling.quickphil.song5";
NSMutableArray *shuffleModes;

@interface QuickPhil : NSObject<LAListener, MPMediaPickerControllerDelegate>
{
    MPMusicPlayerController *musicPlayer;
}
@property (nonatomic, retain) MPMusicPlayerController *musicPlayer;
@end

static inline unsigned char QuickPhilListenerName(NSString *listenerName) {
    unsigned char en;
    if ([listenerName isEqualToString:id1]) {
        en = 0;
    }
    if ([listenerName isEqualToString:id2]) {
        en = 1;
    }
    if ([listenerName isEqualToString:id3]) {
        en = 2;
    }
    if ([listenerName isEqualToString:id4]) {
        en = 3;
    }
    if ([listenerName isEqualToString:id5]) {
        en = 4;
    }
    return en;
}

//get the mediaItemCollections
static void loadPreferences() {
    CFPreferencesAppSynchronize(CFSTR("com.milodarling.quickphil"));
    NSData *data;
    if (!shuffleModes)
        shuffleModes = [[NSMutableArray alloc] init];
    data = (NSData *)CFPreferencesCopyAppValue(CFSTR("song1"), CFSTR("com.milodarling.quickphil"));
    mediaItemCollection1 = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    data = (NSData *)CFPreferencesCopyAppValue(CFSTR("song2"), CFSTR("com.milodarling.quickphil"));
    mediaItemCollection2 = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    data = (NSData *)CFPreferencesCopyAppValue(CFSTR("song3"), CFSTR("com.milodarling.quickphil"));
    mediaItemCollection3 = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    data = (NSData *)CFPreferencesCopyAppValue(CFSTR("song4"), CFSTR("com.milodarling.quickphil"));
    mediaItemCollection4 = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    data = (NSData *)CFPreferencesCopyAppValue(CFSTR("song5"), CFSTR("com.milodarling.quickphil"));
    mediaItemCollection5 = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    /*
    //kill Music
    Class appController = [%c(SBApplicationController) sharedInstance];
    SBApplication *app = [appController applicationWithBundleIdentifier:@"com.apple.Music"];
    if (app.pid > 0)
        kill(app.pid, SIGTERM);
     */
}

@implementation QuickPhil
@synthesize musicPlayer;
//listener called, play the music
-(void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event forListenerName:(NSString *)listenerName {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    MPMediaItemCollection *myCollection;
    unsigned char en = QuickPhilListenerName(listenerName);
    MPMusicShuffleMode shuffleMode;
    //assign the right collection based off of which of the 5 listeners is called
    if (en == 0) {
        myCollection = mediaItemCollection1;
        shuffleMode = [(id)CFPreferencesCopyAppValue(CFSTR("song1-shuffle"), CFSTR("com.milodarling.quickphil")) boolValue] ? MPMusicShuffleModeSongs : MPMusicShuffleModeOff;
    } else if (en == 1) {
        myCollection = mediaItemCollection2;
        shuffleMode = [(id)CFPreferencesCopyAppValue(CFSTR("song2-shuffle"), CFSTR("com.milodarling.quickphil")) boolValue] ? MPMusicShuffleModeSongs : MPMusicShuffleModeOff;
    } else if (en == 2) {
        myCollection = mediaItemCollection3;
        shuffleMode = [(id)CFPreferencesCopyAppValue(CFSTR("song3-shuffle"), CFSTR("com.milodarling.quickphil")) boolValue] ? MPMusicShuffleModeSongs : MPMusicShuffleModeOff;
    } else if (en == 3) {
        myCollection = mediaItemCollection4;
        shuffleMode = [(id)CFPreferencesCopyAppValue(CFSTR("song4-shuffle"), CFSTR("com.milodarling.quickphil")) boolValue] ? MPMusicShuffleModeSongs : MPMusicShuffleModeOff;
    } else {
        myCollection = mediaItemCollection5;
        shuffleMode = [(id)CFPreferencesCopyAppValue(CFSTR("song5-shuffle"), CFSTR("com.milodarling.quickphil")) boolValue] ? MPMusicShuffleModeSongs : MPMusicShuffleModeOff;
    }
    
    //time to actually play the music
    musicPlayer = [MPMusicPlayerController systemMusicPlayer];
    NSLog(@"QuickPhil Listener Accepted");
    if (myCollection){
        NSLog(@"[QuickPhil] We're going in!");
        if ([musicPlayer playbackState] != MPMusicPlaybackStateStopped) {
            NSLog(@"[QuickPhil] Stopping the musica");
            [musicPlayer stop];
        }
        NSLog(@"[QuickPhil] Setting the queue");
        [musicPlayer setQueueWithItemCollection:myCollection];
        NSLog(@"[QuickPhil] Setting shuffleMode: %ld", (long)shuffleMode);
        [musicPlayer setShuffleMode:shuffleMode];
        NSLog(@"[QuickPhil] Play!");
        [musicPlayer play];
        
    } else {
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Error"
                                                         message:[NSString stringWithFormat:@"Please pick a song"]
                                                        delegate:nil
                                               cancelButtonTitle:@"Will do, compadre!"
                                               otherButtonTitles:nil];
        [alert1 performSelector:@selector(show)
                       onThread:[NSThread mainThread]
                     withObject:nil
                  waitUntilDone:NO];
        [alert1 release];
    }
    });
    
}

//activator stuff from here down
+(void)load {
    NSAutoreleasePool *p = [[NSAutoreleasePool alloc] init];
    [[LAActivator sharedInstance] registerListener:[self new] forName:id1];
    [[LAActivator sharedInstance] registerListener:[self new] forName:id2];
    [[LAActivator sharedInstance] registerListener:[self new] forName:id3];
    [[LAActivator sharedInstance] registerListener:[self new] forName:id4];
    [[LAActivator sharedInstance] registerListener:[self new] forName:id5];
    [p release];
}


- (NSString *)activator:(LAActivator *)activator requiresLocalizedGroupForListenerName:(NSString *)listenerName {
    return @"Audio";
}

- (NSString *)activator:(LAActivator *)activator requiresLocalizedTitleForListenerName:(NSString *)listenerName {
    unsigned char en = QuickPhilListenerName(listenerName);
    NSString *title[5] = { @"QuickPhil Queue 1", @"QuickPhil Queue 2", @"QuickPhil Queue 3", @"QuickPhil Queue 4", @"QuickPhil Queue 5" };
    return title[en];
}
- (NSString *)activator:(LAActivator *)activator requiresLocalizedDescriptionForListenerName:(NSString *)listenerName {
    return @"Play the queue you set";
}
- (NSArray *)activator:(LAActivator *)activator requiresCompatibleEventModesForListenerWithName:(NSString *)listenerName {
    return [NSArray arrayWithObjects:@"springboard", @"lockscreen", @"application", nil];
}

- (NSData *)activator:(LAActivator *)activator requiresSmallIconDataForListenerName:(NSString *)listenerName scale:(CGFloat *)scale {
    if (*scale == 1.0) {
        return [NSData dataWithContentsOfFile:@"/Library/PreferenceBundles/QuickPhil.bundle/QuickPhil.png"];
    } else {
        return [NSData dataWithContentsOfFile:@"/Library/PreferenceBundles/QuickPhil.bundle/QuickPhil@2x.png"];
    }
}

- (NSArray *)activator:(LAActivator *)activator requiresExclusiveAssignmentGroupsForListenerName:(NSString *)listenerName {
    return [NSArray arrayWithObjects:@"Audio", nil];
}

@end

%ctor {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    (CFNotificationCallback)loadPreferences,
                                    CFSTR("com.milodarling.quickphil/prefsChanged"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorDeliverImmediately);
    loadPreferences();
}