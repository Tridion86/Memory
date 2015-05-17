//
//  ATHGame.h
//  Memory
//
//  Created by Arnau Timoneda Heredia on 15/04/14.
//  Copyright (c) 2014 Arnau Timoneda Heredia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATHCard.h"
#import "ATHScore.h"

@interface ATHGame : NSObject

@property ATHScore *score;
@property NSMutableArray *cards;
@property BOOL firstMovement;

@end
