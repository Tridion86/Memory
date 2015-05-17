//
//  ATHCard.h
//  Memory
//
//  Created by Arnau Timoneda Heredia on 15/04/14.
//  Copyright (c) 2014 Arnau Timoneda Heredia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATHCard : NSObject

@property NSInteger idPartner;
@property (strong) CALayer *layer;
@property bool completed;

-(BOOL) isCompleted;

@end
