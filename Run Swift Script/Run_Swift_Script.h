//
//  Run_Swift_Script.h
//  Run Swift Script
//
//  Created by Felix Grabowski on 17/11/2016.
//  Copyright © 2016 FelixGrabowski. All rights reserved.
//

#import <Automator/AMBundleAction.h>

@interface Run_Swift_Script : AMBundleAction

- (id)runWithInput:(id)input fromAction:(AMAction *)anAction error:(NSDictionary **)errorInfo;

@end
