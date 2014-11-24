#import <Preferences/Preferences.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CoreFoundation/CoreFoundation.h>

@interface QuickPhilListController: PSListController <MPMediaPickerControllerDelegate> {
    CFStringRef song;
}
@property (nonatomic, retain) MPMusicPlayerController *musicPlayer;
//-(void)viewWillAppear:(BOOL)animated;
//-(void)viewWillDisapper:(BOOL)animated;
@end

@implementation QuickPhilListController
- (id)specifiers {
    if(_specifiers == nil) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"QuickPhil" target:self] retain];
    }
    return _specifiers;
}

-(void) pickSong1
{
    song = CFSTR("song1");
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeAny];
    
    mediaPicker.delegate = self;
    mediaPicker.allowsPickingMultipleItems = YES;
    mediaPicker.prompt = @"Select songs to play";
    
    [self presentModalViewController:mediaPicker animated:YES];
    [mediaPicker release];
}

-(void) pickSong2
{
    song = CFSTR("song2");
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeAny];
    
    mediaPicker.delegate = self;
    mediaPicker.allowsPickingMultipleItems = YES;
    mediaPicker.prompt = @"Select songs to play";
    
    [self presentModalViewController:mediaPicker animated:YES];
    [mediaPicker release];
}

-(void) pickSong3
{
    song = CFSTR("song3");
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeAny];
    
    mediaPicker.delegate = self;
    mediaPicker.allowsPickingMultipleItems = YES;
    mediaPicker.prompt = @"Select songs to play";
    
    [self presentModalViewController:mediaPicker animated:YES];
    [mediaPicker release];
}

-(void) pickSong4
{
    song = CFSTR("song4");
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeAny];
    
    mediaPicker.delegate = self;
    mediaPicker.allowsPickingMultipleItems = YES;
    mediaPicker.prompt = @"Select songs to play";
    
    [self presentModalViewController:mediaPicker animated:YES];
    [mediaPicker release];
}

-(void) pickSong5
{
    song = CFSTR("song5");
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeAny];
    
    mediaPicker.delegate = self;
    mediaPicker.allowsPickingMultipleItems = YES;
    mediaPicker.prompt = @"Select songs to play";
    
    [self presentModalViewController:mediaPicker animated:YES];
    [mediaPicker release];
}

- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection
{
    if (mediaItemCollection) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:mediaItemCollection];
        CFPreferencesSetAppValue ( song, data, CFSTR("com.milodarling.quickphil") );
        CFPreferencesAppSynchronize(CFSTR("com.milodarling.quickphil"));
        CFNotificationCenterPostNotification ( CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.milodarling.quickphil/prefsChanged"), NULL, NULL, false );
    }
    
    [self dismissModalViewControllerAnimated: YES];
}

- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker
{
    [self dismissModalViewControllerAnimated: YES];
}
-(void) respring {
    system("killall -9 SpringBoard");
}
@end

// vim:ft=objc