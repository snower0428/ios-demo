//
//  BBVideoPlayer.h
//  Video
//
//  Created by zhangtianfu on 11-10-13.
//  Copyright 2011 ND WebSoft Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MPMoviePlayerController.h>

@protocol BBVideoPlayerDelegate;


@interface BBVideoPlayer : NSObject {
	MPMoviePlayerController	*m_moviePlayer;
	id						m_delegate;
    BOOL                    m_playing;
    BOOL                    m_isPause;
    
    NSTimeInterval          m_currentInterval;
}

@property(nonatomic, readonly) MPMoviePlayerController *moviePlayer;
@property(nonatomic, assign) BOOL playing;
@property(nonatomic, assign) BOOL isPause;

- (id)initWithContentsOfFile:(NSString*)path frame:(CGRect)frame delegate:(id)delegate;

- (void)showOnView:(UIView*)container;
- (void)prepareToPlay;
- (void)play;
- (void)pause;
- (void)stop;

@end


@protocol BBVideoPlayerDelegate<NSObject>
- (void)BBVideoPlayerDidStop:(BBVideoPlayer*)bbVideoPlayer;
@end
