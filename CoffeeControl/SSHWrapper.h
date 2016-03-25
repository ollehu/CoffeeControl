//
//  SSHWrapper.h
//  libssh2
//
//  Created by Felix Schulze on 01.02.11.
//  Copyright 2010 Felix Schulze. All rights reserved.

#import <Foundation/Foundation.h>


@interface SSHWrapper : NSObject {

}

- (void)connectToHost:(NSString *)host port:(int)port user:(NSString *)user password:(NSString *)password error:(NSError **)error;
- (void)closeConnection;
- (NSString *)executeCommand:(NSString *)command error:(NSError **)error;

@end
