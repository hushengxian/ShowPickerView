//
//  ViewController.m
//  ShowPickerView
//
//  Created by Mac on 2018/4/9.
//  Copyright © 2018年 saint. All rights reserved.
//

#import "ViewController.h"

#define screenWith [UIScreen mainScreen].bounds.size.width

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSIndexPath * indexPath;

// ==============  txtPicker  =================

@property (nonatomic, strong) UITextField * txtPicker;

@property (nonatomic, strong) UIToolbar * toorbar;

@property (nonatomic, strong) UIPickerView * pickerView;

@end

@implementation ViewController

-(UIToolbar *)toorbar {
    if (!_toorbar) {
        _toorbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, screenWith, 44)];
        
        UIBarButtonItem * itemCancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(onClickPickerCancel)];
        
        UIBarButtonItem * itemDone = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(onClickPickerDone)];
        
        UIBarButtonItem * holder = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        _toorbar.items = @[itemCancel,holder,itemDone];
    }
    return _toorbar;
}

-(UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

-(UITextField *)txtPicker {
    if (!_txtPicker) {
        _txtPicker = [[UITextField alloc] init];
        _txtPicker.inputAccessoryView = self.toorbar;
        _txtPicker.inputView = self.pickerView;
    }
    return _txtPicker;
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.txtPicker];
    
    [self keyboardNotif];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellId = @"showPicker";
    UITableViewCell * cell = [tableView  dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }

    cell.textLabel.text = [NSString stringWithFormat:@"-%ld- 点击弹出pickerView",indexPath.row];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_txtPicker becomeFirstResponder];
    // 滚动到tableView底部
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - keyboard Notification

-(void)keyboardNotif {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardWillShow:(NSNotification *)notif {
    CGRect rect = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    NSArray * subviews = [self.view subviews];
    
    for (UIView * sub in subviews) {
        if ([sub isKindOfClass:[UITableView class]]) {
            sub.frame = CGRectMake(0, 0, sub.frame.size.width, [UIScreen mainScreen].bounds.size.height - rect.size.height);
            sub.center = CGPointMake(CGRectGetWidth(self.view.frame)/2.0, sub.frame.size.height/2);
        }
    }
    [UIView commitAnimations];
}

-(void)keyboardWillHide:(NSNotification *)notif {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];

    [self.tableView setFrame:self.view.bounds];
    [UIView commitAnimations];
}

#pragma mark - onClick

-(void)onClickPickerCancel {
    [self.view endEditing:YES];
}

-(void)onClickPickerDone {
    [self.view endEditing:YES];
    
    UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:_indexPath];
    NSInteger row = [self.pickerView selectedRowInComponent:0];
    cell.textLabel.text = [NSString stringWithFormat:@"选中%ld行",row];
}

#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 10;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"选中%ld行",row];
}

@end
