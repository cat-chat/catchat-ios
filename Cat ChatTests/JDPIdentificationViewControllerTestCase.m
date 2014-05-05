//
//  JDPIdentificationViewControllerTestCase.m
//  Cat Chat
//
//  Created by Joel Parsons on 05/05/2014.
//  Copyright (c) 2014 Joel Parsons. All rights reserved.
//

#import <XCTest/XCTest.h>
#define EXP_SHORTHAND
#import "Expecta.h"
//UUT
#import "JDPIdentificationViewController.h"
//other
#import "UIStoryboard+Cat_Chat.h"
#import "JDPStoryboardIdentifiers.h"

@interface JDPIdentificationViewControllerTestCase : XCTestCase
@property (nonatomic, strong) JDPIdentificationViewController * controller;
@end

@implementation JDPIdentificationViewControllerTestCase

- (void)setUp
{
    [super setUp];
    UIStoryboard * storyboard = [UIStoryboard catChatStoryboard];
    self.controller = [storyboard instantiateViewControllerWithIdentifier:JDPIdentificationViewControllerID];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testCellSelectionInFirstSection{
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    expect([self.controller tableView:self.controller.tableView
             willSelectRowAtIndexPath:indexPath]).to.beNil();

    indexPath = [NSIndexPath indexPathForRow:30
                                   inSection:0];
    expect([self.controller tableView:self.controller.tableView
             willSelectRowAtIndexPath:indexPath]).to.beNil();
}

-(void)testCellSelectionInSingupSection{
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    expect([self.controller tableView:self.controller.tableView
             willSelectRowAtIndexPath:indexPath]).to.equal(indexPath);
}

-(void)testSignupCellsHaveNoSelectionStyle{
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell * cell = [self.controller tableView:self.controller.tableView cellForRowAtIndexPath:indexPath];
    expect(cell).toNot.beNil();
    expect(cell.selectionStyle).to.equal(UITableViewCellSelectionStyleNone);

    indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    cell = [self.controller tableView:self.controller.tableView  cellForRowAtIndexPath:indexPath];
    expect(cell.selectionStyle).to.equal(UITableViewCellSelectionStyleNone);
}

@end
