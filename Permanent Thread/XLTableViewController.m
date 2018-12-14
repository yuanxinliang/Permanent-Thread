//
//  XLTableViewController.m
//  Permanent Thread
//
//  Created by XL Yuen on 2018/12/14.
//  Copyright © 2018 XL Yuen. All rights reserved.
//

#import "XLTableViewController.h"
#import "XLPermanentThread.h"

@interface XLTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, strong) XLPermanentThread *thread;

@end

@implementation XLTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)executeTaskClick:(id)sender {
    NSString *str = self.textField.text;
    [self.thread excuteTask:^{
        NSLog(@"执行任务 -- %@ -- %@", [NSThread currentThread], str);
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        self.thread = [[XLPermanentThread alloc] init];
    } else if (indexPath.row == 1) {
        [self.thread stop];
        self.thread = nil;
    }
}


@end
