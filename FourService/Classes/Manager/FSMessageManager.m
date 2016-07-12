//
//  FSMessageManager.m
//  FourService
//
//  Created by Joe.Pen on 11/18/15.
//  Copyright © 2015 JoeP. All rights reserved.
//

#import "FSMessageManager.h"


@implementation FSMessageManager
singleton_implementation(FSMessageManager)
- (id) init
{
    if (self = [super init])
    {
        if (!_messages)
        {
            _messages = [NSMutableArray array];
        }
        if (_messages.count > 0)
        {
            [_messages removeAllObjects];
        }
        [_messages addObjectsFromArray:[FSNotificationForm objectArrayWithKeyValuesArray:[PUtils  readArrayFromDocumentsDirectoryWithName:kCZJPlistFileMessage]]];;
        return self;
    }
    return nil;
}

-(void)addMessageWithObject:(id)obj
{
    if (_messages)
    {
        [_messages addObject:obj];
        [self wirteMessages];
    }
}

-(void)markReadAllMessage
{
    if (_messages)
    {
        for (FSNotificationForm* dict in _messages)
        {
            dict.isRead = YES;
            [self wirteMessages];
        }
    }
}

-(void)readMessageFromPlist
{
    if (_messages)
    {
        if (_messages.count > 0)
        {
            [_messages removeAllObjects];
        }
        [_messages addObjectsFromArray:[FSNotificationForm objectArrayWithKeyValuesArray:[PUtils  readArrayFromDocumentsDirectoryWithName:kCZJPlistFileMessage]]];
    }
}

-(void)wirteMessages
{
    if (_messages)
    {
        NSMutableArray* tmpNotiAry = [NSMutableArray array];
        for (FSNotificationForm* notifyForm in _messages)
        {
            [tmpNotiAry addObject:notifyForm.keyValues];
        }
        BACK(^{
            [PUtils writeArrayToDocumentsDirectory:tmpNotiAry withPlistName:kCZJPlistFileMessage];
        });
        
    }
}


-(void)removeObjAtIndex:(int)index
{
    if (_messages)
    {
        [_messages removeObjectAtIndex:index];
        [self wirteMessages];
    }
}

-(void)removeObjInArray:(NSArray*)removeArray
{
    if (_messages)
    {
        [_messages removeObjectsInArray:removeArray];
        [self wirteMessages];
    }
}


-(void)removeAllMessages
{
    if (_messages)
    {
        [_messages removeAllObjects];
        [self wirteMessages];
    }
}

-(BOOL)isAllReaded
{
    return ([self isAllChatReaded] && [self isAllMessageReaded]);
}

//1.通知消息是否有未读
-(BOOL)isAllMessageReaded
{
    BOOL isAll = YES;
    if (_messages)
    {
        
        for (FSNotificationForm* dict in _messages)
        {
            if (!dict.isRead)
            {
                isAll = NO;
                break;
            }
        }
    }
    return isAll;
}

//2.环信聊天消息是否有未读
-(BOOL)isAllChatReaded
{
    BOOL isAll = YES;
    
//    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
//    for (EMConversation* conversation in conversations)
//    {
//        DLog(@"未读消息数目：%d",[conversation unreadMessagesCount]);
//        if ([conversation unreadMessagesCount] > 0 )
//        {
//            isAll = NO;
//            break;
//        }
//    }
    return isAll;
}


- (void)setMessages:(NSMutableArray *)messages
{
    if (_messages)
    {
        [_messages removeAllObjects];
        _messages = [messages mutableCopy];
        [self wirteMessages];
    }
    else
    {
        _messages = [NSMutableArray array];
        _messages = [messages copy];
        [self wirteMessages];
    }
}

@end
