//
//  FSErrorCodeManager.h
//  FourService
//
//  Created by Joe.Pen on 11/18/15.
//  Copyright © 2015 JoeP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDAlertView.h"

@interface FSErrorCodeManager : NSObject
{
    NSDictionary * _errorInfoDictionary;
    NSDictionary * _errorTypeDictionary;
}
singleton_interface(FSErrorCodeManager)
-(void)ShowErrorInfoWithErrorCode:(NSString *)errorCode;
- (void)ShowNetError;

@end
