//
//  WPTouchStatusGestureRecognizer.h
//  WalletPoC
//
//  Created by Melby Ruarus on 20/08/12.
//  Copyright (c) 2012 Alphero. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 A simple gesture recognizer that changes state whenever any touch
 event occurs.
 
 This makes it usefull for touch down/up notifications
 */
@interface WPTouchStatusGestureRecognizer : UIGestureRecognizer

/** Whether the gesture currently has any touches active */
@property (nonatomic, readonly) BOOL touchDown;
@end
