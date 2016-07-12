//
//  FSMessageManager.h
//  FourService
//
//  Created by Joe.Pen on 11/18/15.
//  Copyright © 2015 JoeP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSMessageManager : NSObject
singleton_interface(FSMessageManager)
@property(nonatomic,retain)NSMutableArray* messages;
-(void)readMessageFromPlist;
-(void)wirteMessages;

-(void)addMessageWithObject:(id)obj;
-(void)removeObjAtIndex:(int)index;
-(void)removeObjInArray:(NSArray*)removeArray;
-(void)removeAllMessages;
-(void)markReadAllMessage;

-(BOOL)isAllReaded;
-(BOOL)isAllMessageReaded;
-(BOOL)isAllChatReaded;

@end
