//
//  ATHBoardViewController.h
//  Memory
//
//  Created by Arnau Timoneda Heredia on 15/04/14.
//  Copyright (c) 2014 Arnau Timoneda Heredia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATHGame.h"
#import <AVFoundation/AVFoundation.h>

@interface ATHBoardViewController : UIViewController

@property ATHGame *mainGame;
@property ATHCard *firstCard;
@property UIImageView *backgroundImage;
@property (nonatomic, strong) AVAudioPlayer *couple;
@property (nonatomic, strong) AVAudioPlayer *wrong;
@property (nonatomic, strong) AVAudioPlayer *endGame;
@property bool readyToPlay;




@end
