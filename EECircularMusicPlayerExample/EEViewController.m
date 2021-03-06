//
//  EEViewController.m
//  EECircularMusicPlayer
//
//  Created by Yoichi Tagaya on 12/10/20.
//  Copyright (c) 2012 Yoichi Tagaya. All rights reserved.
//

#import "EEViewController.h"


@interface EEViewController ()

@property (strong, nonatomic) AVAudioPlayer *audioPlayer; // This is used by playerControl1.
@property (strong, nonatomic) NSTimer *timer; // This is used by playerControl2.
@property (nonatomic) dispatch_source_t timerSource; // This is used by playerControl3.

@end


@implementation EEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //
    // Example 1 (playerControl1)
    // This is an example to update the current time of the control by a delegate.
    // Also this is an example to use AVAudioPlayer to play a music with EECircularMusicPlayerControl.
    //
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Jimdubtrix_XTC-of-Gold-160" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.audioPlayer.delegate = self;
    [self.audioPlayer prepareToPlay];
    self.playerControl1.duration = self.audioPlayer.duration;
    self.playerControl1.delegate = self;
    
    //
    // Example 2 (playerControl2)
    // This is an example to update the current time of the control by yourself.
    // Also this is an example to customize the appearance of EECircularMusicPlayerControl.
    //
    self.playerControl2.duration = 30.0;
    self.playerControl2.progressTrackRatio = 0.4f;
    self.playerControl2.trackTintColor = [UIColor colorWithWhite:190.0f/255.0f alpha:1.0f];
    self.playerControl2.highlightedTrackTintColor = [UIColor colorWithWhite:160.0f/255.0f alpha:1.0f];
    self.playerControl2.progressTintColor = [UIColor colorWithRed:0.0f/255.0f green:88.0f/255.0f blue:219.0f/255.0f alpha:1.0f];
    self.playerControl2.highlightedProgressTintColor = [UIColor colorWithRed:11.0f/255.0f green:76.0f/255.0f blue:176.0f/255.0f alpha:1.0f];
    self.playerControl2.buttonTopTintColor = [UIColor colorWithWhite:240.0f/255.0f alpha:1.0f];
    self.playerControl2.highlightedButtonTopTintColor = [UIColor colorWithWhite:240.0f/255.0f alpha:1.0f];
    self.playerControl2.buttonBottomTintColor = [UIColor colorWithWhite:217.0f/255.0f alpha:1.0f];
    self.playerControl2.highlightedButtonBottomTintColor = [UIColor colorWithWhite:217.0f/255.0f alpha:1.0f];
    self.playerControl2.iconColor = [UIColor colorWithWhite:123.0f/255.0f alpha:1.0f];
    self.playerControl2.highlightedIconColor =[UIColor colorWithWhite:80.0f/255.0f alpha:1.0f];
    
    //
    // Example 3 (playerControl3)
    // This is an example to draw a border.
    //
    self.playerControl3.duration = 20.0;
    self.playerControl3.progressTrackRatio = 0.25f;
    self.playerControl3.trackTintColor = [UIColor clearColor];
    self.playerControl3.highlightedTrackTintColor = [UIColor clearColor];
    self.playerControl3.disabledTrackTintColor = [UIColor clearColor];
    self.playerControl3.progressTintColor = [UIColor colorWithRed:0.0f/255.0f green:88.0f/255.0f blue:219.0f/255.0f alpha:1.0f];
    self.playerControl3.highlightedProgressTintColor = [UIColor colorWithRed:11.0f/255.0f green:76.0f/255.0f blue:176.0f/255.0f alpha:1.0f];
    self.playerControl3.disabledProgressTintColor = [UIColor lightGrayColor];
    self.playerControl3.buttonTopTintColor = [UIColor clearColor];
    self.playerControl3.highlightedButtonTopTintColor = [UIColor clearColor];
    self.playerControl3.disabledButtonTopTintColor = [UIColor clearColor];
    self.playerControl3.buttonBottomTintColor = [UIColor clearColor];
    self.playerControl3.highlightedButtonBottomTintColor = [UIColor clearColor];
    self.playerControl3.disabledButtonBottomTintColor = [UIColor clearColor];
    self.playerControl3.iconColor = [UIColor colorWithRed:0.0f/255.0f green:88.0f/255.0f blue:219.0f/255.0f alpha:1.0f];
    self.playerControl3.highlightedIconColor = [UIColor colorWithRed:11.0f/255.0f green:76.0f/255.0f blue:176.0f/255.0f alpha:1.0f];
    self.playerControl3.disabledIconColor = [UIColor lightGrayColor];
    self.playerControl3.borderColor = [UIColor colorWithRed:0.0f/255.0f green:88.0f/255.0f blue:219.0f/255.0f alpha:1.0f];
    self.playerControl3.highlightedBorderColor = [UIColor colorWithRed:11.0f/255.0f green:76.0f/255.0f blue:176.0f/255.0f alpha:1.0f];
    self.playerControl3.disabledBorderColor = [UIColor lightGrayColor];
    self.playerControl3.borderWidth = 1.0f;
}

- (void)startControl2
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(didControl2TimeChange) userInfo:nil repeats:YES];
}

- (void)stopControl2
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)didControl2TimeChange
{
    NSTimeInterval time = self.playerControl2.currentTime + 0.02;
    self.playerControl2.currentTime = time;
    
    if (self.playerControl2.currentTime >= self.playerControl2.duration && [self.timer isValid])
    {
        [self stopControl2];
        self.playerControl2.playing = NO;
        self.playerControl2.currentTime = 0.0;
    }
}

- (void)startControl3
{
    self.timerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    dispatch_source_set_timer(self.timerSource, dispatch_time(DISPATCH_TIME_NOW, 0), NSEC_PER_SEC / 10.0, 0.0);
    dispatch_source_set_event_handler(self.timerSource, ^{
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           NSTimeInterval time = self.playerControl3.currentTime + 1.0 / 10.0;
                           self.playerControl3.currentTime = time;
                           
                           if (self.playerControl3.currentTime >= self.playerControl3.duration && NULL != self.timerSource)
                           {
                               [self stopControl3];
                               self.playerControl3.playing = NO;
                               self.playerControl3.currentTime = 0.0;
                           }
                       });
    });
    dispatch_source_set_cancel_handler(self.timerSource, ^{
        if(self.timerSource){
            dispatch_release(self.timerSource);
            self.timerSource = NULL;
        }
    });
    dispatch_resume(self.timerSource);
}

- (void)stopControl3
{
    if(self.timerSource){
        dispatch_source_cancel(self.timerSource);
    }
}

- (IBAction)didTouchUpInside:(id)sender
{
    if (sender == self.playerControl1) {
        BOOL startsPlaying = !self.audioPlayer.playing;
        self.playerControl1.playing = startsPlaying;
        if (startsPlaying) {
            [self.audioPlayer play];
        }
        else {
            [self.audioPlayer stop];
            self.audioPlayer.currentTime = 0.0;
            [self.audioPlayer prepareToPlay];
        }
    }
    else if (sender == self.playerControl2) {
        BOOL startsPlaying = !self.playerControl2.playing;
        self.playerControl2.playing = startsPlaying;
        if (startsPlaying) {
            [self startControl2];
        }
        else {
            [self stopControl2];
        }
    }
    else if (sender == self.playerControl3) {
        BOOL startsPlaying = !self.playerControl3.playing;
        self.playerControl3.playing = startsPlaying;
        if (startsPlaying) {
            [self startControl3];
        }
        else {
            [self stopControl3];
        }
    }
}

- (IBAction)didSwitchChangeValue:(id)sender
{
    BOOL enabled = ((UISwitch *)sender).on;
    self.playerControl1.enabled = enabled;
    self.playerControl2.enabled = enabled;
    self.playerControl3.enabled = enabled;
}

#pragma mark - EECircularMusicPlayerControlDelegate
- (NSTimeInterval)currentTime
{
    return self.audioPlayer.currentTime;
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    self.playerControl1.playing = NO;
    [self.audioPlayer prepareToPlay];
}

@end
