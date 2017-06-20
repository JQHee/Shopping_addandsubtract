
#import "HJQAjustNumView.h"

@interface HJQAjustNumView () <UITextFieldDelegate>
{
    NSTimer *_timer;
}

@property (nonatomic, strong)  UIButton *decreaseBtn;
@property (nonatomic, strong)  UIButton *increaseBtn;
// 中间的竖线
@property (nonatomic, strong)  UIView *twoLine;
@property (nonatomic, strong)  UIView *oneLine;
@property (nonatomic, strong)  UITextField *textField;


@end

@implementation HJQAjustNumView


#pragma mark: - setter and setter

- (void)setLineColor:(UIColor *)lineColor{
    _lineColor = lineColor;
    self.layer.borderColor = [lineColor CGColor];
    _oneLine.backgroundColor = lineColor;
    _twoLine.backgroundColor = lineColor;
}

- (void)setCurrentNum:(NSString *)currentNum{
    _textField.text = currentNum;
}

- (NSString *)currentNum{
    return _textField.text;
}

#pragma mark: - lazy load
-(UITextField *)textField {
    if (! _textField) {
        _textField = [[UITextField alloc] init];
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textField.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:15];
        _textField.text = @"1";
        _textField.delegate = self;
    }
    return _textField;
}

- (UIView *)oneLine {
    if (! _oneLine) {
        UIColor *lineColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0];
        _oneLine = [[UIView alloc] init];
        _oneLine.backgroundColor = lineColor;
    }
    return _oneLine;
}

- (UIView *)twoLine {
    if (! _twoLine) {
        UIColor *lineColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0];
        _twoLine = [[UIView alloc] init];
        _twoLine.backgroundColor = lineColor;
    }
    return _twoLine;
}

- (UIButton *)decreaseBtn {
    if (! _decreaseBtn) {
        _decreaseBtn = [[UIButton alloc] init];
        [self setupButton:_decreaseBtn normalImage:@"decrease@2x" HighlightImage:@"decrease2@2x"];
    }
    return _decreaseBtn;
}

- (UIButton *)increaseBtn {
    if (! _increaseBtn) {
        _increaseBtn = [[UIButton alloc] init];
        [self setupButton:_increaseBtn normalImage:@"increase@2x" HighlightImage:@"increase2@2x"];
    }
    return _increaseBtn;
}


#pragma mark: - lift cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIColor *lineColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0];
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 2;
    self.clipsToBounds = YES;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [lineColor CGColor];
    
    [self addSubview:self.oneLine];
    [self addSubview:self.twoLine];
    [self addSubview:self.decreaseBtn];
    [self addSubview:self.increaseBtn];
    [self addSubview:self.textField];

}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self commonSetup];
}

- (void)dealloc{
    [self cleanTimer];
}

#pragma mark: private methods
- (void)commonSetup{
    
    CGFloat viewH = self.bounds.size.height;
    CGFloat viewW = self.bounds.size.width;
    
    _oneLine.frame = CGRectMake(viewH, 0, 1, viewH);
    _twoLine.frame = CGRectMake(viewW - viewH, 0, 1, viewH);
    _increaseBtn.frame = CGRectMake(viewW - viewH, 0, viewH, viewH);
    _decreaseBtn.frame = CGRectMake(0, 0, viewH, viewH);
    _textField.frame = CGRectMake(viewH, 0, viewW - viewH * 2, viewH);
}

- (void)setupButton:(UIButton *)btn normalImage:(NSString *)norImage HighlightImage:(NSString *)highImage{
    [btn setImage:[self readImageFromBundle:norImage] forState:UIControlStateNormal];
    [btn setImage:[self readImageFromBundle:highImage] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnTouchDown:) forControlEvents:UIControlEventTouchDown];
    [btn addTarget:self action:@selector(btnTouchUp:) forControlEvents:UIControlEventTouchUpOutside|UIControlEventTouchUpInside|UIControlEventTouchCancel];
}

- (UIImage *)readImageFromBundle:(NSString *)imageName{
    NSString *bundlePath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"HJQAjustNumButton.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    UIImage *(^getBundleImage)(NSString *) = ^(NSString *n) {
        return [UIImage imageWithContentsOfFile:[bundle pathForResource:n ofType:@"png"]];
    };
    UIImage *myImg = getBundleImage(imageName);
    return myImg;
}


- (void)cleanTimer{
    if (_timer.isValid) {
        [_timer invalidate];
        _timer = nil;
    }
}


#pragma mark: - event response
- (void)btnTouchDown:(UIButton *)btn{
    [_textField resignFirstResponder];
    
    if (btn == _increaseBtn) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(increase) userInfo:nil repeats:YES];
    } else {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(decrease) userInfo:nil repeats:YES];
    }
    [_timer fire];
}

- (void)btnTouchUp:(UIButton *)btn{
    [self cleanTimer];
}

- (void)increase{
    if (_textField.text.length == 0) {
        _textField.text = @"1";
    }
    int newNum = [_textField.text intValue] + 1;
    _textField.text = [NSString stringWithFormat:@"%i", newNum];
    if (self.callBack) {
        self.callBack(_textField.text, increaseType);
    }
}

- (void)decrease{
    if (_textField.text.length == 0) {
        _textField.text = @"1";
    }
    int newNum = [_textField.text intValue] - 1;
    if (newNum > 0) {
        _textField.text = [NSString stringWithFormat:@"%i", newNum];
        if (self.callBack) {
            self.callBack(_textField.text, reduceType);
        }
    } else {
        NSLog(@"num can not less than 1");
    }
}

#pragma mark: - UITextFieldDelegate
// 是否禁止操作
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

@end
