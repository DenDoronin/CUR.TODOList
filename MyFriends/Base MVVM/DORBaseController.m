//
//  CURBaseController.m
//  CURPay
//
//  Created by Doronin Denis on 9/28/15.
//  Copyright © 2015 Doronin Denis. All rights reserved.
//

#import "DORBaseController.h"

@interface DORBaseController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *activeField;
@property (nonatomic,assign) CGPoint keyboardSize;
@property (nonatomic, readonly) UIScrollView *topScrollView;

@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;

@property (nonatomic, strong) NSArray *arrayTextfieldsReturn;

@end

@implementation DORBaseController

@synthesize topScrollView = _topScrollView;
@dynamic view;

- (UIScrollView*) topScrollView {
    
    if (!_topScrollView)
    {
        _topScrollView = [[self.view itemsOfClass:[UIScrollView class]] firstObject];
    }
    
    return  _topScrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSParameterAssert(self.view);
    NSParameterAssert(self.model);

    // Do any additional setup after loading the view from its nib.
    self.model.delegate = self;
    
    [self configureView];
    [self bindViewModel];
    [self.model updateData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)configureView
{
    [self setExtendedLayoutIncludesOpaqueBars:YES];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view decorate];
    
    [self registerViewForKeyboardDismiss];
    [self registerForKeyboardNotifications];
    [self registerTextfieldsForReturnAction];
    
    [self.topScrollView setBounces:NO];
}

- (void)registerViewForKeyboardDismiss
{
    self.tapRecognizer = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    self.tapRecognizer.delegate = self;
    [self.tapRecognizer setCancelsTouchesInView:NO];
    
    [self.view addGestureRecognizer:self.tapRecognizer];
}

- (void)registerTextfieldsForReturnAction
{
    self.arrayTextfieldsReturn = [self.view orderedTextfieldForReturnAction];
    
    for (UITextField * t in self.arrayTextfieldsReturn)
    {
        t.delegate = self;
    }
}

-(void) dismissKeyboard
{
    [TSMessage dismissActiveNotification];
    
    if (self.topScrollView)
    {
        @weakify(self)
        [UIView animateWithDuration:0.2 animations:^
         {
             @strongify(self)
             [self.topScrollView setContentInset:  UIEdgeInsetsZero];
         } completion:^(BOOL finished) {
             @strongify(self)
             [self.topScrollView setContentOffset:CGPointZero animated:YES];
         }];
     
        [self.view endEditing:YES];
        self.activeField = nil;
    }
}



- (void)bindViewModel {
    [self bindTextfieldTextAndError];
    [self bindTextfieldDidBeginEditingAction];
    [self bindTextfieldDidEndEditingAction];
}

- (void) bindTextfieldTextAndError
{
    
}

- (void) bindTextfieldDidEndEditingAction {

    NSString *noteName = UITextFieldTextDidEndEditingNotification;
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:noteName object:nil]
      takeUntil:[self rac_willDeallocSignal]]
     subscribeNext:^(NSNotification *notification) {
         
         UITextField *t = notification.object;
         if (t.validator)
             [t.validator isValidInputValue:t.validator.validatedText];
     }];
    
}

- (void) bindTextfieldDidBeginEditingAction
{
    
    NSString *noteName = UITextFieldTextDidBeginEditingNotification;
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:noteName object:nil]
      takeUntil:[self rac_willDeallocSignal]]
     subscribeNext:^(NSNotification *notification) {
         UITextField *textField = notification.object;
         self.activeField = textField;
         [TSMessage dismissActiveNotification];
         
     }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.topScrollView)
            [self.topScrollView setContentOffset:CGPointZero animated:YES];

    });
    
}

- (void)dealloc
{
    [self unRegisterForKeyboardNotifications];
}


- (void)modelDidUpdate:(id)model
{
    //[self redrawIncludeCommisionButton];
}

- (void)modelDidStartActivity:(id)model
{
   // [self.view setSubviewsEnabled:NO];
    [SVProgressHUD showWithStatus:self.model.activityMessage];
    
    [self.view setTextfieldsEnabled:NO];
    [self.view setButtonsEnabled:NO];
}

- (void)modelDidFinishActivity:(id)model
{
    [self.view setTextfieldsEnabled:YES];
    [self.view setButtonsEnabled:YES];
    [SVProgressHUD popActivity];
}

- (void) modelDidFailWithError:(NSError*) error
{
    NSString *message = [error.userInfo objectForKey:NSLocalizedDescriptionKey];
    
    if (!message)
        message =NSLocalizedString(@"Internal error", nil);
    
    [TSMessage showNotificationInViewController:self.navigationController?:self
                                          title:NSLocalizedString(@"Error", nil)
                                       subtitle:message
                                          image:nil
                                           type:TSMessageNotificationTypeError
                                       duration:TSMessageNotificationDurationAutomatic
                                       callback:nil
                                    buttonTitle:nil
                                 buttonCallback:nil
                                     atPosition:TSMessageNotificationPositionNavBarOverlay
                           canBeDismissedByUser:YES];
}

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardDidHideNotification object:nil];
    
}

- (void)unRegisterForKeyboardNotifications
{
    // unregister for keyboard notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    if (self.topScrollView)
    {
        NSDictionary* info = [aNotification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
        self.topScrollView.contentInset = contentInsets;
        self.topScrollView.scrollIndicatorInsets = contentInsets;
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your app might not need or want this behavior.
        CGRect aRect = self.view.frame;
        aRect.size.height -= kbSize.height;
        if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
            dispatch_async(dispatch_get_main_queue(), ^{
            [self.topScrollView scrollRectToVisible:self.activeField.frame animated:YES];
                 });
        }
    }
}

- (BOOL) hasAnyResponder
{
    for (UITextField *t in self.arrayTextfieldsReturn)
    {
        if([t isFirstResponder]) return YES;
    }
    return NO;
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    if (self.topScrollView && ![self hasAnyResponder])
    {
        [self dismissKeyboard];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger targetIndex = [self.arrayTextfieldsReturn indexOfObject:textField];
    
    [textField resignFirstResponder];
    
    NSInteger nextTargetIndex = targetIndex+1 < self.arrayTextfieldsReturn.count?targetIndex+1:0;
    
    UITextField *nextResponder = self.arrayTextfieldsReturn[nextTargetIndex];
    
    [nextResponder becomeFirstResponder];
    
    return YES;
}




@end
